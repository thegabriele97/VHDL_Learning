library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity alarm_controller is
    port(
        clk, rst: in std_logic;
        n: in std_logic_vector(2 downto 0);
        temperature, threshold: in std_logic_vector(15 downto 0);
        alarm: out std_logic 
    );
end alarm_controller;

architecture hlsm of alarm_controller is

    type fsm_state is ( init, wait_ncc, sample_n_sum, check_th );
    signal curr_state, next_state: fsm_state;
    signal curr_i, next_i: std_logic_vector(1 downto 0);
    signal curr_n, next_n, curr_base_n, next_base_n: std_logic_vector(2 downto 0);
    signal curr_sum, next_sum: std_logic_vector(17 downto 0);

begin

    process(curr_state, curr_i, curr_n, curr_base_n, curr_sum, temperature, threshold)
    begin
    
        next_state <= curr_state;
        alarm <= '0';
        next_i <= curr_i;
        next_n <= curr_n;
        next_base_n <= curr_base_n;
        next_sum <= curr_sum;
        
        case curr_state is
        
            when init =>
                next_n <= curr_base_n;
                next_state <= wait_ncc;
                
            when wait_ncc =>
                next_n <= std_logic_vector(unsigned(curr_n) - 1);
                
                if (curr_n = "010") then
                    next_state <= sample_n_sum;
                end if;
                
            when sample_n_sum =>
                next_i <= std_logic_vector(unsigned(curr_i) + 1);
                next_sum <= std_logic_vector(unsigned(curr_sum) + unsigned(temperature));
                next_n <= curr_base_n;
            
                if (unsigned(curr_i) /= 3) then
                    next_state <= wait_ncc;
                elsif (unsigned(curr_i) = 3) then
                    next_state <= check_th;
                end if;
            
            when check_th =>
                next_sum <= (others => '0');
                
                if (unsigned("00" & curr_sum(17 downto 2)) > unsigned(threshold)) then
                    alarm <= '1';
                end if;
                
                next_state <= wait_ncc;
            
            when others =>
                next_state <= init;
            
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_i <= (others => '0');
                curr_sum <= (others => '0');
                curr_base_n <= n;
                curr_state <= init;
            else
                curr_state <= next_state;
                curr_n <= next_n;
                curr_i <= next_i;
                curr_base_n <= next_base_n;
                curr_sum <= next_sum;
            end if;
        end if;
    
    end process;

end hlsm;

architecture fsmd of alarm_controller is

    --Datapath signals
    signal curr_base_n, next_base_n, curr_n, next_n: std_logic_vector(2 downto 0);
    signal curr_temp, next_temp, curr_threshold, next_threshold: std_logic_vector(15 downto 0);
    signal curr_i, next_i: std_logic_vector(1 downto 0);
    signal curr_sum, next_sum: std_logic_vector(17 downto 0);
    
    --Controller signals
    type fsm_state is ( init, wait_ncc, sample_n_sum, check_th );
    signal curr_state, next_state: fsm_state;
    
    --Control signals
    signal ld_n, ld_sum: std_logic;
    signal en_n, en_i, en_sum: std_logic;
    signal tc_n, tc_i, tc_alarm: std_logic;

begin

    --Datapath description
    process(ld_n, ld_sum, en_n, en_i, en_sum, curr_n, curr_temp, curr_threshold, curr_i, curr_sum, temperature, threshold)
    begin
    
        --N register
        next_n <= curr_n;
    
        if (ld_n = '1') then
            next_n <= curr_base_n;
        elsif (en_n = '1') then
            next_n <= std_logic_vector(unsigned(curr_n) - 1);
        end if;
        
        --Sum register
        next_sum <= curr_sum;
        
        if (ld_sum = '1') then
            next_sum <= (others => '0');
        elsif (en_sum = '1') then
            next_sum <= std_logic_vector(unsigned(curr_sum) + unsigned(curr_temp));
        end if;
        
        --I register
        next_i <= curr_i;
        
        if (en_i = '1') then
            next_i <= std_logic_vector(unsigned(curr_i) + 1);
        end if;
        
        --Temp register
        next_temp <= temperature;
        
        --Threshold register
        next_threshold <= threshold;
        
        --Base_n register
        next_base_n <= curr_base_n;
    
    end process;
    
    tc_n <= '1' when (unsigned(curr_n) = 2) else '0';
    tc_i <= '1' when (unsigned(curr_i) = 3) else '0';
    tc_alarm <= '1' when (unsigned(curr_sum(17 downto 2)) > unsigned(curr_threshold)) else '0';

    process(clk)
    begin
    
        if (rising_edge(clk)) then 
            if (rst = '1') then
                curr_base_n <= n;
                curr_i <= (others => '0');
                curr_sum <= (others => '0');
                curr_temp <= (others => '0');
                curr_threshold <= (others => '0');
                curr_n <= (others => '0');
            else
                curr_temp <= next_temp;
                curr_threshold <= next_threshold;
                curr_n <= next_n;
                curr_sum <= next_sum;
                curr_i <= next_i;
                curr_base_n <= next_base_n;
            end if;
        end if;
    
    end process;
    
    --Controller description
    process(curr_state, tc_i, tc_n, tc_alarm)
    begin
    
        next_state <= curr_state;
        ld_sum <= '0';
        ld_n <= '0';
        en_n <= '0';
        en_sum <= '0';
        en_i <= '0';
        alarm <= '0';
    
        case curr_state is
        
            when init =>
                ld_sum <= '1';
                ld_n <= '1';
                next_state <= wait_ncc;
                
            when wait_ncc =>
                en_n <= '1';
                
                if (tc_n = '1') then
                    next_state <= sample_n_sum;
                end if;
                
            when sample_n_sum =>
                en_sum <= '1';
                en_i <= '1';
                ld_n <= '1';
                
                if (tc_i = '0') then
                    next_state <= wait_ncc;
                elsif (tc_i = '1') then
                    next_state <= check_th;
                end if;
                
            when check_th =>
                alarm <= tc_alarm;
                ld_sum <= '1';
        
                next_state <= wait_ncc;        
        
            when others =>
                next_state <= init;
        
        end case;
        
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init;
            else
                curr_state <= next_state;
            end if;
        end if;
        
    end process;

end fsmd;

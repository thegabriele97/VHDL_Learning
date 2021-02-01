library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity alarm_temp is
    port(
        clk, rst: in std_logic;
        CT, WT: in std_logic_vector(15 downto 0);
        alarm: out std_logic
    );
end alarm_temp;

architecture hlsm of alarm_temp is

    type fsm_state is ( init, sample );
    signal curr_state, next_state: fsm_state;
    
    signal curr_t0, curr_t1, curr_t2, curr_t3, next_t0, next_t1, next_t2, next_t3: std_logic_vector(15 downto 0);
    signal curr_wt, next_wt: std_logic_vector(15 downto 0);

begin

    process(curr_state, curr_t0, curr_t1, curr_t2, curr_t3, curr_wt, CT, WT)
    begin
    
        next_state <= curr_state;
        next_t0 <= curr_t0;
        next_t1 <= curr_t1;
        next_t2 <= curr_t2;
        next_t3 <= curr_t3;
        next_wt <= curr_wt;
        alarm <= '0';
        
        case curr_state is
        
            when init =>
                next_wt <= WT;
                next_state <= sample;
        
            when sample =>
                next_t0 <= ct;
                next_t1 <= curr_t0;
                next_t2 <= curr_t1;
                next_t3 <= curr_t2;
        
                if (unsigned("00" & curr_t0) + unsigned("00" & curr_t1) + unsigned("00" & curr_t2) + unsigned("00" & curr_t3) > unsigned(curr_wt & "00")) then
                    alarm <= '1';
                end if;
                
            when others =>
                next_state <= init;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= init;
            curr_t0 <= (others => '0');
            curr_t1 <= (others => '0');
            curr_t2 <= (others => '0');
            curr_t3 <= (others => '0');
            curr_wt <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_t0 <= next_t0;
            curr_t1 <= next_t1;
            curr_t2 <= next_t2;
            curr_t3 <= next_t3;
            curr_wt <= next_wt;
        end if;
    
    end process;

end hlsm;

architecture fsmd of alarm_temp is

    -- Datapath signals
    signal curr_t0, curr_t1, curr_t2, curr_t3, next_t0, next_t1, next_t2, next_t3: std_logic_vector(15 downto 0);
    signal curr_wt, next_wt: std_logic_vector(15 downto 0);

    -- Controller signals
    type fsm_state is ( init, sample );
    signal curr_state, next_state: fsm_state;

    -- Control signals
    signal ld_t0, ld_t1, ld_t2, ld_t3, ld_wt, ialarm: std_logic;

begin

    process(curr_t0, curr_t1, curr_t2, curr_t3, curr_wt, ld_t0, ld_t1, ld_t2, ld_t3, ld_wt, ct, wt)
    begin
    
        next_t0 <= curr_t0;
        if (ld_t0 = '1') then
            next_t0 <= ct;
        end if;
        
        next_t1 <= curr_t1;
        if (ld_t1 = '1') then
            next_t1 <= curr_t0;
        end if;
        
        next_t2 <= curr_t2;
        if (ld_t2 = '1') then
            next_t2 <= curr_t1;
        end if;
        
        next_t3 <= curr_t3;
        if (ld_t3 = '1') then
            next_t3 <= curr_t2;
        end if;
        
        next_wt <= curr_wt; 
        if (ld_wt = '1') then
            next_wt <= wt;
        end if;
    
        ialarm <= '0';
        if (unsigned("00" & curr_t0) + unsigned("00" & curr_t1) + unsigned("00" & curr_t2) + unsigned("00" & curr_t3) > unsigned(curr_wt & "00")) then
            ialarm <= '1';
        end if;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_t0 <= (others => '0');
            curr_t1 <= (others => '0');
            curr_t2 <= (others => '0');
            curr_t3 <= (others => '0');
            curr_wt <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_t0 <= next_t0;
            curr_t1 <= next_t1;
            curr_t2 <= next_t2;
            curr_t3 <= next_t3;
            curr_wt <= next_wt;
        end if;
    
    end process;
    
    process(curr_state, ialarm)
    begin
    
        next_state <= curr_state;
        ld_t0 <= '0';
        ld_t1 <= '0';
        ld_t2 <= '0';
        ld_t3 <= '0';
        ld_wt <= '0';
        alarm <= '0';
        
        case curr_state is
        
            when init =>
                ld_wt <= '1';
                next_state <= sample;
        
            when sample =>
                ld_t0 <= '1';
                ld_t1 <= '1';
                ld_t2 <= '1';
                ld_t3 <= '1';
            
            if (ialarm = '1') then
                alarm <= '1';
            end if;
            
            when others =>
                next_state <= init;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= init;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end fsmd;

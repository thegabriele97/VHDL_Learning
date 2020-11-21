library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pulse_gen is
    port(
        clk, rst, go, stop: in std_logic;
        pulse: out std_logic
    );
end pulse_gen;

architecture hlsm of pulse_gen is

    type fsm_state is ( init, wait_comm, sh_in, pulse_en );
    signal curr_state, next_state: fsm_state;
    signal curr_cnt, next_cnt, curr_progrm_cnt, next_progrm_cnt: std_logic_vector(2 downto 0);
    signal curr_i, next_i: std_logic_vector(1 downto 0);

begin

    process(curr_state, curr_cnt, curr_i, go, stop)
    begin
    
        next_state <= curr_state;
        next_cnt <= curr_cnt;
        next_i <= curr_i;
        next_progrm_cnt <= curr_progrm_cnt;
        pulse <= '0';
    
        case curr_state is
         
            when init =>
                next_progrm_cnt <= "001";
                next_state <= wait_comm;

            when wait_comm =>
                next_i <= "00";
                next_cnt <= curr_progrm_cnt;
                
                if (go = '1' and stop = '1') then
                    next_state <= sh_in;
                elsif (go = '1' and stop = '0') then
                    next_state <= pulse_en;
                end if;
                
            when sh_in =>
                next_i <= std_logic_vector(unsigned(curr_i) + 1);
                next_progrm_cnt <= go & curr_cnt(2 downto 1);
                
                if (unsigned(curr_i) >= 2) then
                    next_state <= wait_comm;
                end if;
            
            when pulse_en =>
                pulse <= '1';
                next_cnt <= std_logic_vector(unsigned(curr_cnt) - 1);
                
                if (unsigned(curr_cnt) <= 1 or stop = '1') then
                    next_state <= wait_comm;
                end if;
            
            when others =>
                next_state <= init;
            
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init;
                curr_i <= "00";
                curr_cnt <= "000";
                curr_progrm_cnt <= "000";
            else
                curr_state <= next_state;
                curr_cnt <= next_cnt;
                curr_i <= next_i;
                curr_progrm_cnt <= next_progrm_cnt;
            end if;
        end if;
    
    end process;

end hlsm;

architecture fsmd of pulse_gen is

    --Datapath signals
    signal curr_conf_cnt, next_conf_cnt, curr_cnt, next_cnt: std_logic_vector(2 downto 0);
    signal curr_i, next_i: std_logic_vector(1 downto 0);

    --Controller signals
    type fsm_state is ( init, wait_comm, sh_in, pulse_en );
    signal curr_state, next_state: fsm_state;
    
    --Control signals
    signal ld_cnt, ld_i: std_logic;
    signal tc_i, tc_cnt: std_logic;
    signal en_cnt, en_i, en_sh: std_logic;
    
begin

    --Datapath
    process(curr_cnt, en_cnt, ld_cnt, curr_conf_cnt, en_sh, ld_i, curr_i, go)
    begin
    
        --cnt register
        next_cnt <= curr_cnt;
        
        if (en_cnt = '1') then
            next_cnt <= std_logic_vector(unsigned(curr_cnt) - 1);
        elsif (ld_cnt = '1') then
            next_cnt <= curr_conf_cnt;
        end if;
        
        --conf_cnt register
        next_conf_cnt <= curr_conf_cnt;
        
        if (en_sh = '1') then
            next_conf_cnt <= go & curr_conf_cnt(2 downto 1);
        end if;
        
        --i reg
        next_i <= curr_i;
        
        if (ld_i = '1') then
            next_i <= "10";
        elsif (en_i = '1') then
            next_i <= std_logic_vector(unsigned(curr_i) - 1);
        end if;
        
    end process;
    
    tc_cnt <= '1' when (unsigned(curr_cnt) = 1) else '0';
    tc_i <= '1' when (unsigned(curr_i) = 0) else '0';

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_conf_cnt <= "001";
                curr_cnt <= "000";
                curr_i <= "00";
            else
                curr_conf_cnt <= next_conf_cnt;
                curr_cnt <= next_cnt;
                curr_i <= next_i;
            end if;
        end if;
    
    end process;

    --Controller
    process(curr_state, go, stop, tc_cnt, tc_i)
    begin
    
        next_state <= curr_state;
        ld_i <= '0';
        ld_cnt <= '0';
        en_sh <= '0';
        en_i <= '0';
        en_cnt <= '0';
        pulse <= '0';
    
        case curr_state is
        
            when init =>
                next_state <= wait_comm;
        
            when wait_comm =>
                ld_i <= '1';
                ld_cnt <= '1';
                
                if (go = '1' and stop = '1') then
                    next_state <= sh_in;
                elsif (go = '1' and stop = '0') then
                    next_state <= pulse_en;
                end if;
                
            when sh_in =>
                en_sh <= '1';
                en_i <= '1';
                
                if (tc_i = '1') then
                    next_state <= wait_comm;
                end if;
                
            when pulse_en =>
                pulse <= '1';
                en_cnt <= '1';
                
                if (tc_cnt = '1' or stop = '1') then
                    next_state <= wait_comm;
                end if;
                
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

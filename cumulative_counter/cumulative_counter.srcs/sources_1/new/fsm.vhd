library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsm is
    port(
        m, clk, rst: std_logic;
        cnt: out std_logic_vector(3 downto 0)
    );
end fsm;

architecture Behavioral of fsm is

    type fsm_state is ( hold_state, inc_state, init_state );
    signal curr_state, next_state: fsm_state;
    signal int_cnt: std_logic_vector(3 downto 0);
    signal cnt_up: std_logic;

begin

    process(clk, cnt_up, curr_state)
    begin
    
        if (rising_edge(clk)) then
            if (curr_state = init_state) then
                int_cnt <= (others => '0');
            elsif (cnt_up = '1') then
                
            end if;
        end if;
    
    end process;

    process(curr_state, m)
    begin
        
        next_state <= curr_state;
        cnt_up <= '0';
        
        case curr_state is
        
            when init_state =>
                --int_cnt <= (others => '0');
                next_state <= hold_state;
            
            when hold_state =>
                if (m = '1') then
                    next_state <= inc_state;
                end if;
           
            when inc_state =>
                cnt_up <= '1';
                
                if (m = '0') then
                    next_state <= hold_state;
                end if;    
            
        end case;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init_state;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;
    
    cnt <= int_cnt;

end Behavioral;

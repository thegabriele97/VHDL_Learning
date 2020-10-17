library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_1 is
    port(
        b, clk: in std_logic;
        x: out std_logic
    );
end fsm_1;

architecture Behavioral of fsm_1 is

    type state_t is (s_off, s_on1, s_on2, s_on3); 
    signal curr_state, next_state: state_t := s_off;
    
begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;
    
    process(curr_state, b)
    begin
    
        case curr_state is
            
            when s_off =>
                x <= '0';
                
                if (b = '1') then
                    next_state <= s_on1;
                end if;
                
            when s_on1 =>
                x <= '1';
                next_state <= s_on2;
                
            when s_on2 =>
                x <= '1';
                next_state <= s_on3;
                
            when s_on3 =>
                x <= '1';
                next_state <= s_off;
        
        end case;
    
    end process;

end Behavioral;

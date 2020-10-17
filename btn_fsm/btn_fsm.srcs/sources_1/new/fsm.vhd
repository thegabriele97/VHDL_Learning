library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    port( 
        bi, clk: in std_logic;
        bo: out std_logic
    );
end fsm;

architecture Behavioral of fsm is

    type fsm_state is (waiting_for, btn_pressed, btn_waitfor_0);
    signal curr_state, next_state: fsm_state;

begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

    process(curr_state, bi)
    begin
    
        case curr_state is
        
            when waiting_for =>
                bo <= '0';
                
                if (bi = '1') then
                    next_state <= btn_pressed;
                else
                    next_state <= waiting_for;
                end if;
            
            when btn_pressed => 
                bo <= '1';
                next_state <= btn_waitfor_0;
            
            when btn_waitfor_0 =>
                bo <= '0';
                
                if (bi = '0') then
                    next_state <= waiting_for;
                else
                    next_state <= btn_waitfor_0;
                end if;
            
        end case;
    
    end process;

end Behavioral;

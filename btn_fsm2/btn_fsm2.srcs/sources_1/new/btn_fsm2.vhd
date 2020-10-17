library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity btn_fsm2 is
    port(
        btn: in std_logic_vector(1 downto 0);
        clk: in std_logic;
        leds: out std_logic_vector(1 downto 0)
    );
end btn_fsm2;

architecture Behavioral of btn_fsm2 is

    type fsm_state is (waiting_for, pressed_btn1, pressed_btn2, pressed_both);
    signal curr_state, next_state: fsm_state;

begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

    process(curr_state, btn)
    begin
    
        case curr_state is
        
            when waiting_for =>
                leds <= (others => '0');
        
                if (btn = "01") then
                    next_state <= pressed_btn1;
                elsif (btn = "10") then
                    next_state <= pressed_btn2;
                else
                    next_state <= pressed_both;
                end if;
                
            when pressed_btn1 =>
                leds <= "01";
                next_state <= waiting_for;
                
            when pressed_btn2 =>
                leds <= "10";
                next_state <= waiting_for;
            
            when pressed_both =>
                leds <= "11";
                next_state <= waiting_for;
                
        end case;
    
    end process;

end Behavioral;

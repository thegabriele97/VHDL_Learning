library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsm is
    port(
        start, clk, rst: in std_logic;
        gen: out std_logic
    );
end fsm;

architecture Behavioral of fsm is

    type state is ( waiting, execute_0, execute_1 );
    signal curr_state, next_state: state;
    signal int_counter: std_logic_vector(1 downto 0);

begin

    process(curr_state, start)
    begin
    
        case curr_state is
        
            when waiting =>
                gen <= 'Z';
                next_state <= waiting;
                
                if (start = '1') then
                    int_counter <= "00";
                    next_state <= execute_0;
                end if;
            
            when execute_0 =>
                gen <= '0';
                next_state <= execute_1;
                
            when execute_1 => 
                gen <= '1';
                
                if ((unsigned(int_counter) + 1) = "00") then
                    next_state <= waiting;
                else
                    int_counter <= std_logic_vector(unsigned(int_counter) + 1);
                    next_state <= execute_0;
                end if;
            
            when others =>
                next_state <= waiting;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
        if (rising_edge(clk)) then
        
            if (rst = '1') then
                curr_state <= waiting;
            else 
                curr_state <= next_state;
            end if;
            
        end if;
    end process;

end Behavioral;

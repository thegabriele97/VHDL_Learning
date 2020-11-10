library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    port(
        clk, rst: in std_logic;
        reg: out std_logic_vector(1 downto 0)
    );
end fsm;

architecture Behavioral of fsm is

    type fsm_state is (start, middle, finish);
    signal state: fsm_state;
    attribute enum_encoding: string;
    attribute enum_encoding of fsm_state: type is "hot_encoding";

begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                state <= start;
            else
                
                case state is
                    when start =>
                        reg <= "01";
                        state <= middle;
                    
                    when middle =>
                        reg <= "10";
                        state <= finish;
                        
                    when finish =>
                        reg <= "11";
                        state <= start;
                   
                end case;
            
            end if;
        end if;
    
    end process;

end Behavioral;

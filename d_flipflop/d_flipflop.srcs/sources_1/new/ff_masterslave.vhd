library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ff_masterslave is
    port(
        d, rst, clk: in std_logic;
        q: out std_logic
    );
end ff_masterslave;

architecture Behavioral of ff_masterslave is
begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            
            if (rst = '1') then
                q <= '0';
            else
                q <= d;
            end if;
        end if;
    
    end process;

end Behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity and2 is
    port(
        x, y: in std_logic;
        o: out std_logic
    );
end and2;

architecture and2_arch of and2 is
begin
    process(x, y)
    begin
        o <= x and y;
    end process;
end and2_arch;
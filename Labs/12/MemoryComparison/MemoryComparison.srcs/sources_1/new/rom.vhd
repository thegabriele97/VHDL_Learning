library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rom is
    port(
        a: in std_logic_vector(2 downto 0);
        d: out std_logic_vector(3 downto 0)
    );
end rom;

architecture Behavioral of rom is

    type mem_type is array(0 to 2**3-1) of std_logic_vector(3 downto 0);
    signal memory: mem_type := ( x"0", x"1", x"2", x"3", x"f", x"e", x"a", x"9" );

begin

    d <= memory(TO_INTEGER(unsigned(a)));

end Behavioral;

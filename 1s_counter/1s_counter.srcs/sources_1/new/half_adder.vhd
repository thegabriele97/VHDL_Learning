library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    port(
        i: in std_logic_vector(1 downto 0);
        o, c: out std_logic
    );
end half_adder;

architecture half_adder_arch of half_adder is
begin

    o <= i(0) xor i(1);
    c <= i(0) and i(1);

end half_adder_arch;

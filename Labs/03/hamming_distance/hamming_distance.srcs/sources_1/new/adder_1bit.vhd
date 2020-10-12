library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_1bit is
    port(
        a, b: in std_logic;
        sum, c_out: out std_logic
    );
end adder_1bit;

architecture Behavioral of adder_1bit is
begin

    sum <= a xor b;
    c_out <= a and b;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_gate is
    port(
        x: in std_logic_vector(3 downto 0);
        y: out std_logic
    );
end or_gate;

architecture Behavioral of or_gate is
begin

    y <= x(3) or x(2) or x(1) or x(0);

end Behavioral;

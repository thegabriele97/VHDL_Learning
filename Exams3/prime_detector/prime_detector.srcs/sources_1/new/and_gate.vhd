library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_gate is
    port(
        x: in std_logic_vector(2 downto 0);
        y: out std_logic
    );
end and_gate;

architecture Behavioral of and_gate is
begin

    y <= x(2) and x(1) and x(0);

end Behavioral;

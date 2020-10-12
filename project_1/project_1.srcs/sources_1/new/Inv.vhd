library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Inv is
    port(
        x: in std_logic;
        y: out std_logic
    );
end Inv;

architecture Inv_arch of Inv is
begin

    y <= not(x);

end Inv_arch;

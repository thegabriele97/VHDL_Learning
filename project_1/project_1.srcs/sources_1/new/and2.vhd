library ieee;
use ieee.std_logic_1164.all;

entity AND2 is
    port (
        X, Y: in std_logic;
        O:    out std_logic
    );
end AND2;

architecture AND2_ARCH of AND2 is
begin -- architecture
    
    O <= X and Y;
    
end AND2_ARCH;
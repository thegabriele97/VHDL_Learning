library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mpx_2x1 is
    port(
        d: in std_logic_vector(1 downto 0);
        s: in std_logic;
        y: out std_logic
    );
end mpx_2x1;

architecture struct of mpx_2x1 is
begin

    y <= (not(s) and d(0)) or (s and d(1));

end struct;

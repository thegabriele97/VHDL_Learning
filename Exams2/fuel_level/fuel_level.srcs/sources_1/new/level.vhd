library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity level is
    port(
        lev: in std_logic_vector(2 downto 0);
        L: out std_logic
    );
end level;

architecture when_else of level is
begin

    L <= '1' when (lev(2) = '0' and not (lev(1) = '1' and lev(0) = '1')) else '0';

end when_else;

architecture select_when of level is
begin

    with lev select
        L <= '1' when "000",
             '1' when "001",
             '1' when "010",
             '0' when others;

end select_when;
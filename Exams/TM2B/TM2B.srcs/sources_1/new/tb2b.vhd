library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb2b is
    port(
        x: in std_logic_vector(6 downto 0);
        z: out std_logic_vector(2 downto 0)
    );
end tb2b;

architecture beh1 of tb2b is
begin

    process(x)
    begin
    
        if (x(0) = '0') then
            z <= (others => x(0));
        elsif (x(6) = '1') then
            z <= "111";
        elsif (x(5) = '1') then
            z <= "110";
        elsif (x(4) = '1') then
            z <= "101";
        elsif (x(3) = '1') then
            z <= "100";
        elsif (x(2) = '1') then
            z <= "011";
        elsif (x(1) = '1') then
            z <= "010";
        elsif (x(0) = '1') then
            z <= "001";
        end if;
    
    end process;

end beh1;

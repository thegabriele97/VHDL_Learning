library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity excess3 is
    port(
        bcd: in std_logic_vector(3 downto 0);
        exc3: out std_logic_vector(3 downto 0)
    );
end excess3;

architecture dfl1 of excess3 is
begin

    exc3 <= "0011" when (bcd = "0000") else
            "0100" when (bcd = "0001") else
            "0101" when (bcd = "0010") else
            "0110" when (bcd = "0011") else
            "0111" when (bcd = "0100") else
            "1000" when (bcd = "0101") else
            "1001" when (bcd = "0110") else
            "1010" when (bcd = "0111") else
            "1011" when (bcd = "1000") else
            "1100" when (bcd = "1001");

end dfl1;

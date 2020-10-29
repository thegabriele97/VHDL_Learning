library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2_7seg is
    port(
        d_in: std_logic_vector(3 downto 0);
        dot_enable, enable: std_logic;
        seg: out std_logic_vector(7 downto 0)   -- lsb: g - msb-1: a - 7th: dp
    );
end bin2_7seg;

architecture Behavioral of bin2_7seg is

    signal int_seg: std_logic_vector(7 downto 0);

begin

    with d_in select
        int_seg(6 downto 0) <= "1111110" when x"0",
                               "0110000" when x"1",
                               "1101101" when x"2",
                               "1111001" when x"3",
                               "0110011" when x"4",
                               "1011011" when x"5",
                               "0011111" when x"6",
                               "1110000" when x"7",
                               "1111111" when x"8",
                               "1110011" when x"9",
                               "1110111" when x"a",
                               "0011111" when x"b",
                               "1001110" when x"c",
                               "0111101" when x"d",
                               "1001111" when x"e",
                               "1000111" when x"f",
                               "ZZZZZZZ" when others;
         
      int_seg(7) <= dot_enable;
      seg <= int_seg when (enable = '1') else (others => '0');      

end Behavioral;

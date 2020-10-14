library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ALU is
    generic(
        nbit: integer := 8
    );
    port(
        src1, src2: in std_logic_vector((nbit-1) downto 0);
        ctrl: in std_logic_vector(2 downto 0);
        result: out std_logic_vector((nbit-1) downto 0)
    );
end ALU;

architecture DataFl of ALU is
begin

    with ctrl select
        result <= std_logic_vector(signed(src1) + 1) when "000" | "001" | "010" | "011",
                  std_logic_vector(signed(src1) + signed(src2)) when "100",
                  std_logic_vector(signed(src1) - signed(src2)) when "101",
                  (src1 and src2) when "110",
                  (src1 or src2) when "111",
                  (others => 'X') when others;

end DataFl;

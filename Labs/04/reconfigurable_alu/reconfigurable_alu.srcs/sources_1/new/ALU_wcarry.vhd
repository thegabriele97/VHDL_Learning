library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ALU_wcarry is
    generic(
        nbit: integer := 8
    );
    port(
        src1, src2: in std_logic_vector((nbit-1) downto 0);
        ctrl: in std_logic_vector(2 downto 0);
        result: out std_logic_vector((nbit-1) downto 0);
        c_out: out std_logic
    );
end ALU_wcarry;

architecture DataFl of ALU_wcarry is

    signal int_result: signed(nbit downto 0);

begin

    with ctrl select
        int_result <= (('0' & signed(src1)) + 1) when "000" | "001" | "010" | "011",
                      (('0' & signed(src1)) + ('0' & signed(src2))) when "100",
                      (('0' & signed(src1)) - signed(src2)) when "101",
                      signed((('0' & src1) and ('0' & src2))) when "110",
                      signed((('0' & src1) or ('0' & src2))) when "111",
                      (others => 'X') when others;

        result <= std_logic_vector(int_result((nbit-1) downto 0));
        c_out <= int_result(nbit);

end DataFl;
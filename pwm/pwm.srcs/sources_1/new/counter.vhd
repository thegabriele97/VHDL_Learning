library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity counter is
    generic(
        nbits: integer
    );
    port(
        clk, rst: in std_logic;
        
        en: in std_logic;
        val: out std_logic_vector((nbits-1) downto 0)
        
    );
end counter;

architecture Behavioral of counter is

    signal curr_cnt, next_cnt: std_logic_vector((nbits-1) downto 0);
    
begin

    val <= curr_cnt;

    next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_cnt <= (others => '0');
        elsif (rising_edge(clk) and en = '1') then
            curr_cnt <= next_cnt;
        end if;

    end process;

end Behavioral;

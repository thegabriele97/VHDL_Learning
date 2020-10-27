library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity counter is
    generic(
        nbits: integer := 32
    );
    port(
        rst, up, en, clk: in std_logic;
        cnt: out std_logic_vector((nbits-1) downto 0)
    );
end counter;

architecture Behavioral of counter is
    
    signal int_cnt: std_logic_vector((nbits-1) downto 0);

begin

    process(clk, rst, en, up)
    begin
    
        if (rst = '1') then
            int_cnt <= (others => '0');
        elsif (rising_edge(clk) and en = '1') then
            if (up = '1') then
                int_cnt <= std_logic_vector((unsigned(int_cnt) + 1));
            else
                int_cnt <= std_logic_vector((unsigned(int_cnt) - 1));
            end if;
        end if;
    
    end process;
    
    cnt <= int_cnt;

end Behavioral;

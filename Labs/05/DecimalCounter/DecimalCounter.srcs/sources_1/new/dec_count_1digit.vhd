library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity dec_count_1digit is
    port(
        clk, enable, rst: in std_logic;
        last_cnt: out std_logic;
        cnt: out std_logic_vector(3 downto 0)    
    );
end dec_count_1digit;

architecture Behavioral of dec_count_1digit is

    signal int_counter: std_logic_vector(3 downto 0); 

begin
    
    process(clk, enable, rst)
    begin
    
        if (rst = '1') then
            int_counter <= (others => '0');
        elsif (rising_edge(clk) and enable = '1') then
            int_counter <= std_logic_vector((unsigned(int_counter) + 1) mod 10);
        end if;
    
    end process;
    
    last_cnt <= '1' when (int_counter = x"9" and enable = '1') else '0';
    cnt <= int_counter;

end Behavioral;

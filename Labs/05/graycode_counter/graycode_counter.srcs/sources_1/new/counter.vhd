library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity counter is
    generic(
        nbits: integer := 4
    );    
    port(
        en, clk, rst: in std_logic;
        d: out std_logic_vector((nbits-1) downto 0)
    );
end counter;

architecture Behavioral of counter is
    
    signal int_counter, shifted_counter: std_logic_vector((nbits-1) downto 0);
    
begin

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                int_counter <= (others => '0');
            elsif (en = '1') then
                int_counter <= std_logic_vector(unsigned(int_counter) + 1);
            end if;
        end if;
    
    end process;
    
    shifted_counter <= '0' & int_counter((nbits-1) downto 1);
    d <= int_counter xor shifted_counter;   -- gray code := bin(i) xor bin(i+1)

end Behavioral;

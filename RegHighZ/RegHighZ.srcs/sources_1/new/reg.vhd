library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    port(
        oe, ld, clk, rst: std_logic;
        i: in std_logic_vector(3 downto 0);
        q: out std_logic_vector(3 downto 0)
    );
end reg;

architecture Behavioral of reg is

    signal int_reg: std_logic_vector(3 downto 0);
    
begin
    
    process(clk, rst, ld, i)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                int_reg <= (others => '0');
            elsif (ld = '1') then
                int_reg <= i;
            end if;
        end if;
    
    end process;
    
    q <= int_reg when (oe = '1') else (others => 'Z');

end Behavioral;

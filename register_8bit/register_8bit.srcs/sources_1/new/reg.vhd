library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    generic (
        nbits: integer := 8
    );
    port(
        d: in std_logic_vector((nbits-1) downto 0);
        clk, cs, rst: in std_logic;
        q: out std_logic_vector((nbits-1) downto 0)
    );
end reg;

architecture Behavioral of reg is

    signal internal_mem: std_logic_vector((nbits-1) downto 0);

begin

    process(clk, d, rst)
    begin
        
        if (rst = '1') then
            internal_mem <= (others => '0');
        elsif (rising_edge(clk)) then
            internal_mem <= d;
        end if;
    
    end process;
    
    process(cs)
    begin
    
        if (cs = '1') then
            q <= internal_mem;
        else
            q <= (others => 'Z');
        end if;
    
    end process;

end Behavioral;

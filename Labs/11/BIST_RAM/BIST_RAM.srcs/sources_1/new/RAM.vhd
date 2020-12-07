library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity RAM is
    generic(
        k, n: integer
    );
    port(
        clk, rst, rw: in std_logic;
        a: in std_logic_vector((k-1) downto 0);
        x: in std_logic_vector((n-1) downto 0);
        z: out std_logic_vector((n-1) downto 0)
    );
end RAM;

architecture Behavioral of RAM is

    type ram_mem is array(0 to 2**k-1) of std_logic_vector((n-1) downto 0);
    signal memory: ram_mem;

begin

    process(a, rw)
    begin
    
        z <= (others => 'Z');
        if (rw = '0') then
            z <= memory(TO_INTEGER(unsigned(a)));
        end if;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                memory <= (others => (others => '0'));
            elsif (rw = '1') then
                memory(TO_INTEGER(unsigned(a))) <= x;
            end if;
        end if;
    
    end process;


end Behavioral;

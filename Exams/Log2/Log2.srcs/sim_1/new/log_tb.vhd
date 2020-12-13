library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity log_tb is
end log_tb;

architecture Behavioral of log_tb is

    component log is
        generic(
            n: integer := 4
        );
        port(
            clk, rst, start: in std_logic;
            x: in std_logic_vector((2**n-1) downto 0);
            l: out std_logic_vector(n downto 0);
            ready: out std_logic
        );
    end component;
    
    constant n: integer := 4;
    signal clk, rst, start, ready: std_logic := '0';
    signal x: std_logic_vector((2**n-1) downto 0);
    signal l: std_logic_vector(n downto 0);

begin

    DUT: log port map(clk, rst, start, x, l, ready);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;
    
    process
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        x <= x"0001";
        start <= '1';
        wait until ready = '1';
        
        x <= x"0007";
        start <= '1';
        wait until ready = '1';
        
        x <= x"0138";
        start <= '1';
        wait until ready = '1';
        
        x <= x"1230";
        wait until ready = '1';
        
        start <= '0';
        wait;
    
    end process;

end Behavioral;

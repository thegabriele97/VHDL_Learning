library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fib_tb is
end fib_tb;

architecture Behavioral of fib_tb is

    component fib is
        port(
            clk, rst, start: in std_logic;
            n: in std_logic_vector(3 downto 0);
            ready: out std_logic;
            data_out: out std_logic_vector(9 downto 0)
        );
    end component;

    for DUT: fib use entity work.fib(fsmd);

    signal clk, rst, start, ready: std_logic := '0';
    signal n: std_logic_vector(3 downto 0);
    signal data: std_logic_vector(9 downto 0);

begin

    DUT: fib port map(clk, rst, start, n, ready, data);
    
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
        
        n <= x"3";
        start <= '1';
        
        wait until ready = '1';
        n <= x"f";
        
        wait until ready = '1';
        start <= '0';
        
        wait;
    
    end process;

end Behavioral;

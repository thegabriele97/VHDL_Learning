library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_mult_tb is
end seq_mult_tb;

architecture behav of seq_mult_tb is

    component sequential_mult is
        port(
            clk, rst, start: in std_logic;
            a, b: in std_logic_vector(7 downto 0);
            res: out std_logic_vector(15 downto 0);
            ready: out std_logic
        );
    end component;

    for DUT: sequential_mult use entity work.sequential_mult(fsmd);

    signal clk, rst, start, ready: std_logic := '0';
    signal a, b: std_logic_vector(7 downto 0);
    signal res: std_logic_vector(15 downto 0);

begin

    DUT: sequential_mult port map(clk, rst, start, a, b, res, ready);

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
        
        a <= x"1a";
        b <= x"1a";
        start <= '1';
        wait for 1 ns;
        
        start <= '0';
        wait;
        
    end process;

end behav;

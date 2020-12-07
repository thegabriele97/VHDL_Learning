library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity binomial_tb is
end binomial_tb;

architecture Behavioral of binomial_tb is

    component binomial is
        port(
            clk, rst, start: in std_logic;
            n, k: in std_logic_vector(2 downto 0);
            ready: out std_logic;
            data_out: out std_logic_vector(5 downto 0)
        );
    end component;
    
    signal clk, rst, start, ready: std_logic := '0';
    signal n, k: std_logic_vector(2 downto 0);
    signal data_out: std_logic_vector(5 downto 0);

begin

    DUT: binomial port map(clk, rst, start, n, k, ready, data_out);
    
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
        wait for 0 ns;
        
        n <= "001";
        k <= "001";
        start <= '1';
        wait until ready = '1';
        
        n <= "111";
        k <= "011";
        start <= '1';
        wait until ready = '1';
        
        n <= "111";
        k <= "101";
        start <= '1';
        wait until ready = '1';
        
        start <= '0';
        wait;
    
    end process;

end Behavioral;

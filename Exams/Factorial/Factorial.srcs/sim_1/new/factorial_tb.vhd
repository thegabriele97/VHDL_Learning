library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity factorial_tb is
end factorial_tb;

architecture Behavioral of factorial_tb is

    component factorial is
        port(
            clk, rst, start: in std_logic;
            n: in std_logic_vector(2 downto 0);
            ready: out std_logic;
            data_out: out std_logic_vector(12 downto 0)
        );
    end component;
    
    for DUT: factorial use entity work.factorial(fsmd);

    signal clk, rst, start, ready: std_logic := '0';
    signal n: std_logic_vector(2 downto 0);
    signal data_out: std_logic_vector(12 downto 0);
    
begin

    DUT: factorial port map(clk, rst, start, n, ready, data_out);

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
        
        n <= "011";
        start <= '1';
        
        wait until ready = '1';
        n <= "111";
        
        wait until ready = '1';
        start <= '0';
        
        wait;
    
    end process;

end Behavioral;

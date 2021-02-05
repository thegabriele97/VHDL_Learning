library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jaco_tb is
end jaco_tb;

architecture Behavioral of jaco_tb is

    component jaco is
        port(
            clk, rst, start: in std_logic;
            n: in std_logic_vector(3 downto 0);
            ready: out std_logic;
            J: out std_logic_vector(13 downto 0)
        );
    end component;

    signal clk,rst, start, ready: std_logic := '0';
    signal n: std_logic_vector(3 downto 0);
    signal j: std_logic_vector(13 downto 0);

begin

    DUT: jaco port map(clk, rst, start, n, ready, j);

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
        
        n <= x"0";
        start <= '1';
        wait until ready = '1';
        wait for 1 ns;
        
        n <= x"4";
        start <= '1';
        wait until ready = '1';
        wait for 1 ns;
        
        n <= x"a";
        start <= '1';
        wait until ready = '1';
        wait for 1 ns;
        
        n <= x"f";
        start <= '1';
        wait until ready = '1';        
        
        start <= '0';
        wait;
    
    end process;

end Behavioral;

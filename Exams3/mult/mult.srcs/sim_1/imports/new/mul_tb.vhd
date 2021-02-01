library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mul_tb is
end mul_tb;

architecture Behavioral of mul_tb is

    component mult is
        port(
            clk, rst, start: in std_logic;
            a, b: in std_logic_vector(7 downto 0);
            ready: out std_logic;
            z: out std_logic_vector(15 downto 0)
        );
    end component;
    
    for DUT: mult use entity work.mult(fsmd);
    
    signal clk, rst, start, ready: std_logic := '0';
    signal a, b: std_logic_vector(7 downto 0);
    signal z: std_logic_vector(15 downto 0);
    
begin

    DUT: mult port map(clk, rst, start, a, b, ready, z);
    
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
        
        a <= x"00";
        b <= x"6e";
        start <= '1';
        wait until ready = '1';
        
        a <= x"03";
        b <= x"02";
        start <= '1';
        wait until ready = '1';
        
        a <= x"56";
        b <= x"64";
        wait until ready = '1';
    
        start <= '0';
        wait;
    
    end process;

end Behavioral;

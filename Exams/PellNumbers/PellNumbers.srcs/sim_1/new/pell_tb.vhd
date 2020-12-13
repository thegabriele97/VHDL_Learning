library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pell_tb is
end pell_tb;

architecture Behavioral of pell_tb is

    component pell is
        port(
            clk, rst, start: in std_logic;
            n: in std_logic_vector(2 downto 0);
            p: out std_logic_vector(7 downto 0);
            ready: out std_logic
        );
    end component;

    for DUT: pell use entity work.pell(fsmd);

    signal clk, rst, start, ready: std_logic := '0';
    signal n: std_logic_vector(2 downto 0);
    signal p: std_logic_vector(7 downto 0);

begin

    DUT: pell port map(clk, rst, start, n, p, ready);
    
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
        
        n <= "010";
        start <= '1';
        wait for 1 ns;
        wait until ready = '1';
        
        n <= "111";
        start <= '1';
        wait for 1 ns;
        wait until ready = '1';
        
        start <= '0';
        wait;
    
    end process;

end Behavioral;

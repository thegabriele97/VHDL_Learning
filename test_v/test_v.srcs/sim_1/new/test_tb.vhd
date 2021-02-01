library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_tb is
end test_tb;

architecture Behavioral of test_tb is

    component test is
        port (
            clk, rst: in std_logic;
            c: out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk, rst: std_logic := '0';
    signal c: std_logic_vector(3 downto 0);

begin

    DUT: test port map(clk, rst, c);

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
        
        wait;
    
    end process;

end Behavioral;

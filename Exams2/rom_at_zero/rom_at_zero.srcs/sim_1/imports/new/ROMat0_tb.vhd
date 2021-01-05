library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ROMat0_tb is
end ROMat0_tb;

architecture Behavioral of ROMat0_tb is

    component TopLevel is
        port(
            clk, rst, go: in std_logic;
            finish: out std_logic;
            counter: out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk, rst, go, finish: std_logic := '0';
    signal cnt: std_logic_vector(3 downto 0);

begin

    DUT: TopLevel port map(clk, rst, go, finish, cnt);

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
    
        go <= '1';
        wait until finish = '1';
    
        go <= '0';
        wait;
    
    end process;

end Behavioral;

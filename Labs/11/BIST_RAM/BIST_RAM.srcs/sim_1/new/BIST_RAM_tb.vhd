library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BIST_RAM_tb is
end BIST_RAM_tb;

architecture Behavioral of BIST_RAM_tb is

    component TopLevel is
        port(
            clk, rst, go: in std_logic;
            finish, error: out std_logic
        );
    end component;

    signal clk, rst, go, finish, error: std_logic := '0';

begin

    DUT: TopLevel port map(clk, rst, go, finish, error);

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
        wait until finish <= '1';
        
        go <= '0';
        wait;    
    
    end process;

end Behavioral;

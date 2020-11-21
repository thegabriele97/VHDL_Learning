library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pulse_gen_tb is
end pulse_gen_tb;

architecture Behavioral of pulse_gen_tb is

    component pulse_gen is
        port(
            clk, rst, go, stop: in std_logic;
            pulse: out std_logic
        );
    end component;

    for DUT: pulse_gen use entity work.pulse_gen(fsmd);

    signal clk, rst, go, stop, pulse: std_logic := '0';

begin
    
    DUT: pulse_gen port map(clk, rst, go, stop, pulse);

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
        stop <= '1';
        wait for 1 ns;
        
        go <= '0';
        wait for 2 ns;
        
        stop <= '0';
        go <= '1';
        wait for 9 ns;
        
        stop <= '1';
        wait for 1 ns;
        
        go <= '0';
        stop <= '0';
        wait for 5 ns;
        
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 2 ns;
        
        go <= '1';
        wait for 1 ns;
        
        go <= '0';
        wait;
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_tb is
end fsm_tb;

architecture Behavioral of fsm_tb is

    component fsm is
        port(
            clk, reset, start, stop: in std_logic;
            run: out std_logic
        );
    end component;

    for DUT: fsm use entity work.fsm(behav_2proc);

    signal clk, rst, start, stop, run: std_logic := '0';

begin

    DUT: fsm port map(clk, rst, start, stop, run);

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
        
        start <= '1';
        wait for 2 ns;
        
        stop <= '1';
        wait for 2 ns;
        
        start <= '1';
        wait for 4 ns;
        
        stop <= '1';
        wait for 1 ns;
        
        start <= '0';
        wait;
    
    end process;

end Behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity btn_sync_tb is
end entity;

architecture behav of btn_sync_tb is

    component debouncer_v is
        port(
            clk, rst, bi: in std_logic;
            bo: out std_logic
        );
    end component;

    signal clk, rst, bi, bo: std_logic := '0';

begin

    DUT: debouncer_v port map(clk, rst, bi, bo);
    
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
        
        bi <= '1';
        wait for 3 ns;
        
        bi <= '0';
        wait;
    
    end process;
    
end behav;
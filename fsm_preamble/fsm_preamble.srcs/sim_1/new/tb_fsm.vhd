library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm is
end tb_fsm;

architecture Behavioral of tb_fsm is

    component fsm is
        port(
            start, clk, rst: in std_logic;
            gen: out std_logic
        );
    end component;
        
    signal start, clk, rst, gen: std_logic := '0';
    
begin

    test: fsm port map(start, clk, rst, gen);
    
    process
    begin
        wait for 0.5 ns;
        clk <= not(clk);   
    end process;

    process
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        start <= '1';
        wait for 8 ns;
        
        start <= '0';
        wait;
    
    end process;

end Behavioral;

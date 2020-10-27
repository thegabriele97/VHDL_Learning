library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb2_fsm is
end tb2_fsm;

architecture Behavioral of tb2_fsm is

    component fsm is
        port(
            updw, clk, rst: in std_logic;
            cnt: out std_logic_vector(3 downto 0) 
        );
    end component;
    
    for test: fsm use entity work.fsm(moore);
    
    signal updw, clk, rst: std_logic := '0';
    signal cnt: std_logic_vector(3 downto 0);

begin

    test: fsm port map(updw, clk, rst, cnt);
    
    process
    begin
        
        wait for 1 ns;
        clk <= not clk;
    
    end process;

    process
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 0.5 ns;
        
        for i in 0 to 9 loop
            updw <= not updw;
            wait for 1.5 ns;
        end loop;
        
        wait;
    
    end process;

end Behavioral;

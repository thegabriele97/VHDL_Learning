library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture Behavioral of tb is

    component fsm_1 is
        port(
            b, clk: in std_logic;
            x: out std_logic
        );
    end component;

    signal b_s, clk_s, x_s: std_logic := '0';

begin

    test: fsm_1 port map(b_s, clk_s, x_s);

    process
    begin
    
        wait for 10 ns;
        clk_s <= not(clk_s);
    
    end process;

    process
    begin
    
        b_s <= '0';
        wait for 29 ns;
        
        b_s <= '1';
        wait for 5 ns;
        
        b_s <= '0';
        wait for 10 ns;
        
        b_s <= '1';
        wait for 5 ns;
        
        b_s <= '0';
        wait for 10 ns;
        wait;
        
    end process;

end Behavioral;

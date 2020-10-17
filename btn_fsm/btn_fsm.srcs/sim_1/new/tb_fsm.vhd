library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm is
end tb_fsm;

architecture Behavioral of tb_fsm is

    component fsm is
        port( 
            bi, clk: in std_logic;
            bo: out std_logic
        );
    end component;

    signal clk_s, bi_s, bo_s: std_logic := '0';

begin

    test: fsm port map(bi_s, clk_s, bo_s);

    process
    begin
        
        wait for 10 ns;
        clk_s <= not(clk_s);
    
    end process;

    process
    begin
    
        bi_s <= '1';
        wait for 3 ns;
        
        bi_s <= '0';
        wait for 10 ns;
        
        bi_s <= '1';
        wait for 40 ns;
        
        bi_s <= '0';
        wait for 2 ns;
        
        bi_s <= '1';
        wait for 8 ns;
        
        bi_s <= '0';
        wait for 13 ns;
    
    end process;

end Behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity latch_tb is
end latch_tb;

architecture latch_tb_arch of latch_tb is

    component ff_masterslave is
        port(
            d, rst, clk: in std_logic;
            q: out std_logic
        );
    end component;

    signal d_s, rst_s, clk_s, q_s: std_logic := '1';
    
begin

    test: ff_masterslave port map(d_s, rst_s, clk_s, q_s);
    
    process
    begin 
    
        clk_s <= not(clk_s);
        wait for 10 ns;
    
    end process;
    
    process
    begin
        
        rst_s <= '0';
        wait for 7 ns;
        
        d_s <= '1';
        wait for 10 ns;
        
        d_s <= '0';
        wait for 14 ns;
        
        d_s <= '1';
        wait for 10 ns;
        
        rst_s <= '1';
        wait for 8 ns;
        
        rst_s <= '0';
        d_s <= '1';
        wait for 3 ns;
        
    end process;

end latch_tb_arch;
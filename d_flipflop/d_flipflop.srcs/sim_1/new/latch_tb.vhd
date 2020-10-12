library ieee;
use ieee.std_logic_1164.all;

entity latch_tb is
end latch_tb;

architecture latch_tb_arch of latch_tb is

    component latch is
        port(
            q, q_c: inout std_logic
        );
    end component;

    signal q_s, q_c_s: std_logic;
    
begin

    latch_test: latch port map(q_s, q_c_s);
    
    process
    begin
        
        q_s <= '1';
        q_c_s <= '0';
        wait for 10ns;
        
        q_s <= '0';
        q_c_s <= '1';
        wait for 10ns;
        
        q_s <= '0';
        q_c_s <= '1';
        wait for 10ns;
        
        q_s <= '0';
        q_c_s <= '1';
        wait for 10ns;
        
        q_s <= '1';
        q_c_s <= '0';
        wait for 10ns;
        
        q_s <= '0';
        q_c_s <= '1';
        wait for 10ns;
        
        q_s <= '0';
        q_c_s <= '1';
        wait for 10ns;
        
        q_s <= '0';
        q_c_s <= '1';
        wait for 10ns;
        
        q_s <= '0';
        q_c_s <= '1';
        wait for 10ns;
        
    end process;

end latch_tb_arch;
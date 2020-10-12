library ieee;
use ieee.std_logic_1164.all;

entity fulladder_tb is
end fulladder_tb;

architecture fulladder_tb_arch of fulladder_tb is

    component fulladder is
        port(
            a,b: in std_logic;
            sum, carry: out std_logic
        );
    end component;
    
    signal a_s, b_s, sum_s, carry_s: std_logic;
    
begin
    
    fulladder_test: fulladder port map(a_s, b_s, sum_s, carry_s);

    process
    begin
        a_s <= '0';
        b_s <= '0';
        wait for 10 ns;
        
        a_s <= '0';
        b_s <= '1';
        wait for 10 ns;
        
        a_s <= '1';
        b_s <= '0';
        wait for 10 ns;
        
        a_s <= '1';
        b_s <= '1';
        wait for 10ns;
    end process;

end fulladder_tb_arch;
library ieee;
use ieee.std_logic_1164.all;

entity and2_tb is
end and2_tb;

architecture and2_tb_arch of and2_tb is

    component and2 is
        port(
            x, y: in std_logic;
            o: out std_logic
        );
    end component;
    
    signal x_s, y_s, o_s: std_logic;
    
begin

    and2_test: and2 port map(x_s, y_s, o_s);
    
    process
    begin
        x_s <= '0';
        y_s <= '0';
        wait for 10 ns;
        
        x_s <= '0';
        y_s <= '1';
        wait for 10 ns;
        
        x_s <= '1';
        y_s <= '0';
        wait for 10 ns;
        
        x_s <= '1';
        y_s <= '1';
        wait;
    end process;

end and2_tb_arch;

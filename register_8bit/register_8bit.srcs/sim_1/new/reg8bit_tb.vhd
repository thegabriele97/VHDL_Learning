library ieee;
use ieee.std_logic_1164.all;

entity reg8bit_tb is
end reg8bit_tb;

architecture reg8bit_tb_arch of reg8bit_tb is

    component reg8bit is
        port(
            d_in: in std_logic_vector(7 downto 0);
            d_out: out std_logic_vector(7 downto 0);
            oe: in std_logic; -- Output Enable. 0 for High Impedance
            load: in std_logic -- Load data in memory
        );
    end component;

    signal d_in_s, d_out_s: std_logic_vector(7 downto 0);
    signal oe_s, load_s: std_logic;

begin

    reg8bit_test: reg8bit port map(d_in_s, d_out_s, oe_s, load_s);

    process
    begin
    
        d_in_s <= "00011010";
        load_s <= '1';
        wait for 10ns;
        
        load_s <= '0';
        d_in_s <= "XXXXXXXX";
        wait for 10ns;
        
        oe_s <= '1';
        wait for 10ns;
        
        oe_s <= '0';
        wait for 30ns;
    
    end process;

end reg8bit_tb_arch;
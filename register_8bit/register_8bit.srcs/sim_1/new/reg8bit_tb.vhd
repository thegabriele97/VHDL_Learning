library ieee;
use ieee.std_logic_1164.all;

entity reg8bit_tb is
end reg8bit_tb;

architecture reg8bit_tb_arch of reg8bit_tb is

    component reg is
        generic (
            nbits: integer := 8
        );
        port(
            d: in std_logic_vector((nbits-1) downto 0);
            clk, cs, rst: in std_logic;
            q: out std_logic_vector((nbits-1) downto 0)
        );
    end component;

    signal d_s, q_s: std_logic_vector(7 downto 0);
    signal c_s, clk_s, rst_s: std_logic := '0';

begin

    reg8bit_test: reg port map(d_s, clk_s, c_s, rst_s, q_s);

    process
    begin
    
        wait for 10 ns;
        clk_s <= not(clk_s);
    
    end process;

    process
    begin
    
        rst_s <= '1';
        wait for 2 ns;
        
        rst_s <= '0';
        wait for 2 ns;
    
        d_s <= "00011010";
        c_s <= '0';
        rst_s <= '0';
        wait for 10ns;
        
        c_s <= '1';
        wait for 10ns;
        
        d_s <= "00011110";
        wait for 10ns;
        
        c_s <= '0';
        wait for 10ns;
    
        rst_s <= '1';
        wait for 10 ns;
        
        c_s <= '1';
        wait for 10 ns;
        
        d_s <= "11111111";
        wait for 10 ns;
    
    end process;

end reg8bit_tb_arch;
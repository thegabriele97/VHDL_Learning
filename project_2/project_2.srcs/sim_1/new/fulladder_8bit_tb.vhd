library ieee;
use ieee.std_logic_1164.all;

entity fulladder_8bit_tb is
end fulladder_8bit_tb;

architecture fulladder_8bit_tb_arch of fulladder_8bit_tb is
    
    component fulladder_8bit is
        port(
            d: in std_logic_vector(7 downto 0);
            c_in: in std_logic;
            s: out std_logic_vector(7 downto 0);
            c_out: out std_logic
        );
    end component;
    
    signal c_in_s, c_out_s: std_logic;
    signal d_s, s_s: std_logic_vector(7 downto 0);
    
begin

    fulladder_8bit_test: fulladder_8bit port map(d_s, c_in_s, s_s, c_out_s);
    
    process
    begin
        
        d_s <= "00000000";
        c_in_s <= '1';
        wait;
    
    end process;

end fulladder_8bit_tb_arch;
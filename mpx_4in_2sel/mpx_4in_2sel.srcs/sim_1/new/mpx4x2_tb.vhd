library ieee;
use ieee.std_logic_1164.all;

entity mpx4x2_tb is
end mpx4x2_tb;

architecture mpx4x2_tb_arch of mpx4x2_tb is

    component mpx4x2 is
        port(
            i: in std_logic_vector(3 downto 0);
            s: in std_logic_vector(1 downto 0);
            ce: in std_logic;
            o: out std_logic
        );
    end component;
    
    signal i_s: std_logic_vector(3 downto 0);
    signal s_s: std_logic_vector(1 downto 0);
    signal ce_s, o_s: std_logic;
    
begin

    mpx4x2_test: mpx4x2 port map(i_s, s_s, ce_s, o_s);
    ce_s <= '1';
    
    process
    begin
        i_s <= "0110";
        
        s_s <= "00";
        wait for 10 ns;
        
        s_s <= "01";
        wait for 10 ns;
        
        s_s <= "10";
        wait for 10 ns;
        
        s_s <= "11";
        wait for 10 ns;
            
    end process;

end mpx4x2_tb_arch;

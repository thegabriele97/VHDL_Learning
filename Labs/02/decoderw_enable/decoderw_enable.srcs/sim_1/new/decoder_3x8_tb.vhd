library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_3x8_tb is
end decoder_3x8_tb;

architecture decoder_3x8_tb_arch of decoder_3x8_tb is
    
    component decoder_3x8 is
        port(
            i: in std_logic_vector(2 downto 0);
            cs: in std_logic;
            s: out std_logic_vector(7 downto 0)
        );
    end component;
    
    for decoder_3x8_test: decoder_3x8 use entity work.decoder_3x8(Behav_Case);
    
    signal i_s: std_logic_vector(2 downto 0);
    signal cs_s: std_logic := '0';
    signal s_s: std_logic_vector(7 downto 0);
    
begin

    decoder_3x8_test: decoder_3x8 port map(i_s, cs_s, s_s);
    
    process
    begin
    
        i_s <= "000";
        wait for 10 ns;
        
        i_s <= "010";
        wait for 10 ns;
        
        i_s <= "100";
        wait for 10 ns;
        
        i_s <= "001";
        wait for 10 ns;
        
        i_s <= "101";
        wait for 10 ns;
        
        i_s <= "011";
        wait for 10 ns;
        
        i_s <= "111";
        wait for 10 ns;
        
        cs_s <= not(cs_s);
    
    end process;

end decoder_3x8_tb_arch;

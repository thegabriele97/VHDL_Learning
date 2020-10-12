library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mpx4_2_tb is
end mpx4_2_tb;

architecture Behavioral of mpx4_2_tb is
    
    component mpx4_2 is
        port(
            i: in std_logic_vector(3 downto 0);
            s: in std_logic_vector(1 downto 0);
            cs: in std_logic;
            o: out std_logic
        );
    end component;
    
    signal i_s: std_logic_vector(3 downto 0);
    signal s_s: std_logic_vector(1 downto 0);
    signal cs_s: std_logic := '0';
    signal o_s: std_logic;
    
begin

    mpx4_2_test: mpx4_2 port map(i_s, s_s, cs_s, o_s);

    process
    begin
    
        i_s <= "0110";
        s_s <= "00";
        wait for 10 ns;
    
        s_s <= "10";
        wait for 10 ns;
        
        i_s <= "1001";
        wait for 10 ns;
        
        i_s <= "0100";
        wait for 10 ns;
    
        cs_s <= not(cs_s);
        wait for 10 ns;
    
    end process;

end Behavioral;

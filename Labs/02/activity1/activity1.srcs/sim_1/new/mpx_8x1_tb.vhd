library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mpx_8x1_tb is
end mpx_8x1_tb;

architecture Behavioral of mpx_8x1_tb is

    component mpx_8x1 is
        port(
            d: in std_logic_vector(7 downto 0);
            s: in std_logic_vector(2 downto 0);
            y: out std_logic
        );
    end component;

    signal d_s: std_logic_vector(7 downto 0);
    signal s_s: std_logic_vector(2 downto 0);
    signal y_s: std_logic;
    
    for mpx_test: mpx_8x1 use entity work.mpx_8x1(struct);
    
begin

    mpx_test: mpx_8x1 port map(d_s, s_s, y_s);
    
    process
    begin
    
        d_s <= "00111100";
        s_s <= "011";
        wait for 10 ns;
            
        s_s <= "100";
        wait for 10 ns;
        
        d_s <= "11001011";
        wait for 10 ns;
        
        s_s <= "111";
        wait for 10 ns;
        
    end process;

end Behavioral;

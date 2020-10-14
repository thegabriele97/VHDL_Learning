library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture Behavioral of tb is

    component hamming_dist is
        port(
            a, b: in std_logic_vector(7 downto 0);
            dist: out std_logic_vector(3 downto 0)
        );
    end component;

    signal a_s, b_s: std_logic_vector(7 downto 0);
    signal dst_s: std_logic_vector(3 downto 0);

begin

    test: hamming_dist port map(a_s, b_s, dst_s);

    process
    begin
    
        a_s <= "10100101";
        b_s <= "11111111";
        wait for 10 ns;
        
        b_S <= "00000000";
        wait for 10 ns;
        
        b_s <= "01010101";
        wait for 10 ns;
        
        a_s <= "10111100";
        wait for 10 ns;
    
    end process;

end Behavioral;

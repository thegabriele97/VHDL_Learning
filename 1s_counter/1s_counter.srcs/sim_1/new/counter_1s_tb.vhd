library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_1s_tb is
end counter_1s_tb;

architecture Behavioral of counter_1s_tb is
  
    component counter_1s is
        port(
            d: in std_logic_vector(7 downto 0);
            s: inout std_logic_vector(3 downto 0)
        );
    end component;
  
    for counter_1s_test: counter_1s use entity work.counter_1s(counter_1s_arch_v2);
  
    signal d_s: std_logic_vector(7 downto 0);
    signal s_s: std_logic_vector(3 downto 0);

begin

    counter_1s_test: counter_1s port map(d_s, s_s);
    
    process
    begin
    
        d_s <= "00000000";
        wait for 10 ns;
        
        d_s <= "00000001";
        wait for 10 ns;
        
        d_s <= "00000010";
        wait for 10 ns;
        
        d_s <= "11111111";
        wait for 10 ns;
        
        d_s <= "00110010";
        wait for 10 ns;
        
        d_s <= "10101010";
        wait for 10 ns;
    
    end process;

end Behavioral;

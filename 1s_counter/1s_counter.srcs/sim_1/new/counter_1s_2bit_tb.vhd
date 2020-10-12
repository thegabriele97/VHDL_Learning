library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_1s_2bit_tb is
end counter_1s_2bit_tb;

architecture Behavioral of counter_1s_2bit_tb is

    component counter_1s_2bit is
        port(
            d: in std_logic_vector(1 downto 0);
            o: out std_logic_vector(1 downto 0)
        );
    end component;
  
    signal d_s: std_logic_vector(7 downto 0);
    signal s_s: std_logic_vector(3 downto 0);

begin

    counter_1s_test: counter_1s_2bit port map(d_s(1 downto 0), s_s(1 downto 0));
    
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

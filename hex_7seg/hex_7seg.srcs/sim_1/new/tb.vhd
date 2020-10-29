library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture Behavioral of tb is

    component bin2_7seg is
        port(
            d_in: std_logic_vector(3 downto 0);
            dot_enable, enable: std_logic;
            seg: out std_logic_vector(7 downto 0)   -- lsb: g - msb-1: a - 7th: dp
        );
    end component;
    
    signal d_in: std_logic_vector(3 downto 0);
    signal dot_enable, enable: std_logic;
    signal seg: std_logic_vector(7 downto 0);

begin

    dut: bin2_7seg port map(d_in, dot_enable, enable, seg);
    
    process
    begin
    
        enable <= '1';
        dot_enable <= '0';
        
        d_in <= x"0";
        wait for 1 ns;
        
        d_in <= x"1";
        wait for 1 ns;
        
        d_in <= x"2";
        wait for 1 ns;
        
        d_in <= x"3";
        wait for 1 ns;
        
        d_in <= x"4";
        wait for 1 ns;
        
        d_in <= x"5";
        wait for 1 ns;
        
        d_in <= x"6";
        wait for 1 ns;
        
        d_in <= x"7";
        wait for 1 ns;
        
        d_in <= x"8";
        wait for 1 ns;
        
        d_in <= x"9";
        wait for 1 ns;
        
        d_in <= x"a";
        wait for 1 ns;
        
        wait;
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture Behavioral of tb is

    component gray_inc is
        generic(
            n: integer := 4
        );
        port(
            gray_code: in std_logic_vector((n-1) downto 0);
            next_code: out std_logic_vector((n-1) downto 0)
        );
    end component;

    signal gray_in, gray_out: std_logic_vector(3 downto 0);

begin

    test: gray_inc generic map(4) port map(gray_in, gray_out);
    
    process
    begin
    
        gray_in <= "0000";
        wait for 10 ns;
    
        gray_in <= "0010";
        wait for 10 ns;
        
        gray_in <= "0100";
        wait for 10 ns;
        
        gray_in <= "0110";
        wait for 10 ns;
    
        gray_in <= "1010";
        wait for 10 ns;
    
        gray_in <= "1011";
        wait for 10 ns;
        
        gray_in <= "0111";
        wait for 10 ns;
    
        gray_in <= "1110";
        wait for 10 ns;
    
        gray_in <= "1111";
        wait for 10 ns;
        wait;
        
    end process;
    
end Behavioral;

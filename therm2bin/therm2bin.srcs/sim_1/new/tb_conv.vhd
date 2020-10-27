library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_conv is
end tb_conv;

architecture Behavioral of tb_conv is

    component therm2bin is
        generic(
            nbits_in, nbits_out: integer := 8 
        );    
        port(
            therm: in std_logic_vector((nbits_in-1) downto 0);
            bin: out std_logic_vector((nbits_out-1) downto 0)
        );
    end component;

    signal therm: std_logic_vector(6 downto 0);
    signal bin: std_logic_vector(2 downto 0);

begin

    test: therm2bin generic map(7, 3) port map(therm, bin);
    
    process
    begin
    
        therm <= "0000000";
        wait for 1 ns;
        assert bin = "000";
        
        therm <= "0000001";
        wait for 1 ns;
        assert bin = "001";
        
        therm <= "0000011";
        wait for 1 ns;
        assert bin = "010";
        
        therm <= "0000111";
        wait for 1 ns;
        assert bin = "011";
        
        therm <= "0001111";
        wait for 1 ns;
        assert bin = "100";
    
        therm <= "0011111";
        wait for 1 ns;
        assert bin = "101";
        
        therm <= "0111111";
        wait for 1 ns;
        assert bin = "110";
        
        therm <= "1111111";
        wait for 1 ns;
        assert bin = "111";
    
    end process;

end Behavioral;

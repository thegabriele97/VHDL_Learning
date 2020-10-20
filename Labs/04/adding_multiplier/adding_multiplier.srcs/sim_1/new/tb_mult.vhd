library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mult is
end tb_mult;

architecture Behavioral of tb_mult is

    component multiplier is
        port(
            a, b: in std_logic_vector(7 downto 0);
            y: out std_logic_vector(15 downto 0)
        );
    end component;

    signal a, b: std_logic_vector(7 downto 0);
    signal y: std_logic_vector(15 downto 0);

begin

    test: multiplier port map(a, b, y);
    
    process
    begin
    
        a <= x"02";
        b <= x"02";
        wait for 10 ns;
        assert y = x"0004" report "2x2 should be eq to 4";
    
        b <= x"03";
        wait for 10 ns;
        assert y = x"0006" report "2x3 should be eq to 6";
    
        a <= x"00";
        wait for 10 ns;
        assert y = x"0000" report "0x3 should be eq to 0";
    
        a <= x"05";
        b <= x"04";
        wait for 10 ns;
        assert y = x"0014" report "5x4 should be eq to 20";
        
        a <= x"07";
        b <= x"04";
        wait for 10 ns;
        assert y = x"001c" report "7x4 should be eq to 28";
        
        a <= x"10";
        b <= x"02";
        wait for 10 ns;
        assert y = x"0020" report "16x2 should be eq to 32";
        
        a <= x"10";
        b <= x"0F";
        wait for 10 ns;
        assert y = x"00f0" report "16x15 should be eq to 240";
        
        wait;
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mul is
end tb_mul;

architecture Behavioral of tb_mul is

    component multiplier is
        generic(
            nbits: integer := 4
        );
        port(
            a, b: in std_logic_vector((nbits-1) downto 0);
            y: out std_logic_vector((2*nbits-1) downto 0)
        );
    end component;

    signal a, b: std_logic_vector(7 downto 0);
    signal y: std_logic_vector((2*8-1) downto 0);

begin

    test: multiplier generic map(8) port map(a, b, y);

    process
    begin
    
        a <= x"02";
        b <= x"03";
        wait for 10 ns;
        assert y = x"0006" report "2*3 should be equal to 6";
    
        a <= x"0a";
        b <= x"0a";
        wait for 10 ns;
        assert y = x"0064" report "10*10 should be equal to 100";
    
        a <= x"1e";
        b <= x"46";
        wait for 10 ns;
        assert y = x"0834" report "30*70 should be equal to 2100";
    
        wait;
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cnt4 is
end tb_cnt4;

architecture Behavioral of tb_cnt4 is

    component counter is
        generic(
            nbits: integer := 4
        );    
        port(
            en, clk, rst: in std_logic;
            d: out std_logic_vector((nbits-1) downto 0)
        );
    end component;
    
    signal en, clk, rst: std_logic := '0';
    signal d: std_logic_vector(3 downto 0);

begin

    test: counter generic map(4) port map(en, clk, rst, d);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
        
    end process;

    process
    begin
    
        rst <= '1';
        en <= '0';
        wait for 1 ns;
        assert d = "0000" report "d not all 0 pattern after reset";
        
        rst <= '0';
        wait for 0 ns;
        
        en <= '1';
        wait for 10 ns;
        assert d = "1111" report "after 10 clock cycles, d should be 1111";
        
        en <= '0';
        wait for 2 ns;
        
        en <= '1';
        wait for 5 ns;
        assert d = "100" report "after 15 clock cycles, d should be 1000";       
        
        en <= '0';
        wait;
        
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cnt is
end tb_cnt;

architecture Behavioral of tb_cnt is

    component counter is
        generic(
            nbits: integer := 32
        );
        port(
            rst, up, en, clk: in std_logic;
            cnt: out std_logic_vector((nbits-1) downto 0)
        );
    end component;

    signal rst, up, en, clk: std_logic := '0';
    signal cnt: std_logic_vector(15 downto 0);

begin

    test: counter generic map(16) port map(rst, up, en, clk, cnt);

    process
    begin
    
        wait for 5 ns;
        clk <= not(clk);
    
    end process;
    
    process
    begin
    
        rst <= '1';
        wait for 2 ns;
        assert cnt = x"0000" report "cnt not 0 after reset";
    
        rst <= '0';
        en <= '0';
        wait for 10 ns;
        assert cnt = x"0000" report "cnt not 0 after reset end en=0";
        
        for i in 0 to 10 loop
            en <= '1';
            up <= '1';
            wait for 10 ns;
        end loop;
        assert cnt = x"000b"  report "cnt not 11 after eleven up";
    
        en <= '0';
        wait for 10 ns;
        assert cnt = x"000b" report "cnt not 11 after en=0";
    
        for i in 0 to 1 loop
            en <= '1';
            up <= '0';
            wait for 10 ns;
        end loop;
        assert cnt = x"0009"  report "cnt not 9 after two not up";
        
        en <= '0';
        wait;
    
    end process;

end Behavioral;

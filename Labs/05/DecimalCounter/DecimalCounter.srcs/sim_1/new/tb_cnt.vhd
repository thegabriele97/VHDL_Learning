library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cnt is
end tb_cnt;

architecture Behavioral of tb_cnt is

    component dec_counter is
        generic(
            ndigits: integer := 3
        );
        port(
            clk, enable, rst: in std_logic;
            end_cnt: out std_logic;
            cnt: out std_logic_vector((4*ndigits-1) downto 0)
        );
    end component;

    signal clk, enable, rst, end_cnt: std_logic := '0';
    signal cnt: std_logic_vector(11 downto 0);
    
begin

    dut: dec_counter generic map(3) port map(clk, enable, rst, end_cnt, cnt);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    begin
    
        rst <= '1';
        wait for 1 ns;
        assert cnt = x"000" report "cnt not 0 after reset";
        
        rst <= '0';
        wait for 2 ns;
        
        enable <= '1';
        wait for 9 ns;
        
        enable <= '0';
        wait for 2 ns;
        assert cnt = x"009" report "cnt not 9 after 9 cc and enable = 0 for 2 cc";
    
        enable <= '1';
        wait for 2 ns;
        
        enable <= '0';
        wait for 2 ns;
        assert cnt = x"011" report "cnt not 11 after other 2 cc and enable = 0 for other 2 cc";
        
        
        -- resetting again
        rst <= '1';
        wait for 1 ns;
        assert cnt = x"000" report "cnt not 0 after reset";
        
        rst <= '0';
        wait for 2 ns;
        
        enable <= '1';
        wait for 999 ns;
        assert end_cnt = '1' report "end_cnt should be eq to 1 if cnt is 999";
        
        enable <= '0';
        wait for 2 ns;
        assert cnt = x"999" report "cnt not 999 after 999 cc and enable = 0 for 2 cc";
        
    
        wait;
        
    end process;

end Behavioral;

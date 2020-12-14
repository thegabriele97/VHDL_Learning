library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ram_tb is
end ram_tb;

architecture Behavioral of ram_tb is

    component RAM is
        generic(
            k, n: integer
        );
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            
            rw          : in std_logic;
            oe          : in std_logic;
            cs          : in std_logic;
            
            addr        : in std_logic_vector((k-1) downto 0);
            data        : inout std_logic_vector((n-1) downto 0)
        );
    end component;
    
    constant k: integer := 4;
    constant n: integer := 8;
    
    signal clk: std_logic := '0';
    signal cs: std_logic := '1';
    signal rst, rw, oe: std_logic;
    signal addr: std_logic_vector((k-1) downto 0);
    signal data: std_logic_vector((n-1) downto 0);
    
begin

    DUT: RAM generic map(k, n) port map(clk, rst, rw, oe, cs, addr, data);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
        
    end process;
    
    process
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        addr <= x"5";
        data <= x"f3";
        rw <= '0';
        wait for 1 ns;
        
        addr <= x"a";
        data <= x"69";
        rw <= '0';
        wait for 1 ns;
    
        addr <= x"0";
        data <= x"fa";
        rw <= '0';
        wait for 1 ns;
    
        addr <= x"7";
        data <= (others => 'Z');
        rw <= '1';
        oe <= '0';
        wait for 1 ns;
        assert data = "ZZZZZZZZ" report "line not in high-z with oe=0";
        
        oe <= '1';
        
        addr <= x"1";
        rw <= '1';
        wait for 1 ns;
        assert data = x"00" report "0x1: not equal to 0x00";
        
        addr <= x"f";
        rw <= '1';
        wait for 1 ns;
        assert data = x"00" report "0xf: not equal to 0x00";
        
        oe <= '0';
        wait for 1 ns;
        assert data = "ZZZZZZZZ" report "line not in high-z with oe=0";
        
        oe <= '1';
    
        addr <= x"a";
        rw <= '1';
        wait for 1 ns;
        assert data = x"69" report "0xa: not equal to 0x69";
    
        rw <= '1';
        wait;
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mxm_tb is
end mxm_tb;

architecture Behavioral of mxm_tb is

    component MXM is
        generic(
            r           : integer;
            c           : integer;
            w           : integer
        );
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            
            rw          : in std_logic;
            oe          : in std_logic;
            cs          : in std_logic;
            
            row         : in std_logic_vector((r-1) downto 0);
            col         : in std_logic_vector((c-1) downto 0);
            data        : inout std_logic_vector((w-1) downto 0)
        );
    end component;

    constant r, c: integer := 5;
    constant w: integer := 8;
    
    signal clk: std_logic := '0';
    signal cs: std_logic := '1';
    signal rst, rw, oe: std_logic := '0';
    
    signal row: std_logic_vector((r-1) downto 0);
    signal col: std_logic_vector((c-1) downto 0);
    signal data: std_logic_vector((w-1) downto 0);
    
begin

    DUT2: MXM generic map(r, c, w) port map(clk, rst, rw, oe, cs, row, col, data);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
        
    end process;
    
    process
    begin
    
        rst <= '1';
        rw <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        row <= "00101";
        col <= "00001";
        data <= x"f3";
        rw <= '0';
        wait for 1 ns;
        
        row <= "01010";
        col <= "00010";
        data <= x"69";
        rw <= '0';
        wait for 1 ns;
    
        row <= "00000";
        col <= "00100";
        data <= x"fa";
        rw <= '0';
        wait for 1 ns;
    
        row <= "00111";
        col <= "01000";
        data <= (others => 'Z');
        rw <= '1';
        oe <= '0';
        wait for 1 ns;
        assert data = "ZZZZZZZZ" report "line not in high-z with oe=0";
        
        oe <= '1';
        
        row <= "00001";
        col <= "00100";
        rw <= '1';
        wait for 1 ns;
        assert data = x"00" report "00001/00100: not equal to 0x00";
        
        row <= "01111";
        col <= "00010";
        rw <= '1';
        wait for 1 ns;
        assert data = x"00" report "01111/00010: not equal to 0x00";
        
        oe <= '0';
        wait for 1 ns;
        assert data = "ZZZZZZZZ" report "line not in high-z with oe=0";
        
        oe <= '1';
    
        row <= "01010";
        col <= "00010";
        rw <= '1';
        wait for 1 ns;
        assert data = x"69" report "01010/00010: not equal to 0x69";
    
        rw <= '1';
        oe <= '0';
        wait;
        
    end process;

end Behavioral;

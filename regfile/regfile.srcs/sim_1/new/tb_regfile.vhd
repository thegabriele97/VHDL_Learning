library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_regfile is
end tb_regfile;

architecture Behavioral of tb_regfile is

    component regfile is
        generic(
            nbits: integer := 32;
            nregs_pow2: integer := 2
        );
        port(
            we, re, clk, rst: in std_logic;
            waddr, raddr: in std_logic_vector((nregs_pow2-1) downto 0);
            wdata: in std_logic_vector((nbits-1) downto 0);
            rdata: out std_logic_vector((nbits-1) downto 0)
        );
    end component;

    signal we, re, clk, rst: std_logic := '0';
    signal waddr, raddr: std_logic_vector(1 downto 0);
    signal wdata, rdata: std_logic_vector(7 downto 0);

begin

    test: regfile generic map(8, 2) port map(we, re, clk, rst, waddr, raddr, wdata, rdata);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    begin
    
        wdata <= x"09";
        waddr <= "11";
        wait for 0.2 ns;
        we <= '1';
        wait for 1 ns;
        
        wdata <= x"16";
        waddr <= "01";
        wait for 1 ns;
        
        we <= '0';
        
        raddr <= "11";
        wait for 0.2 ns;
        re <= '1';
        wait for 1 ns;
        
        re <= '0';
        wait for 1 ns;
        
        wdata <= x"b1";
        waddr <= "10";
        we <= '1';
        raddr <= "01";
        re <= '1';
        wait for 1 ns;
        
        wdata <= x"2b";
        waddr <= "11";
        we <= '1';
        raddr <= "11";
        re <= '1';
        wait for 1 ns;
    
    end process;

end Behavioral;

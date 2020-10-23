library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_reg is
--  Port ( );
end tb_reg;

architecture Behavioral of tb_reg is

    component multifcn_reg is
        generic(
            nbits: integer := 4
        );
        port(
            d_in: in std_logic_vector((nbits-1) downto 0);
            sh_in, clk: in std_logic; 
            op: in std_logic_vector(1 downto 0);
            d_out: out std_logic_vector((nbits-1) downto 0)
        );
    end component;
    
    signal sh_in, clk: std_logic := '0';
    signal d_in, d_out: std_logic_vector((8-1) downto 0);
    signal op: std_logic_vector(1 downto 0);

begin

    test: multifcn_reg generic map(8) port map(d_in, sh_in, clk, op, d_out);

    process
    begin
    
        wait for 1 ns;
        clk <= not(clk);
    
    end process;
    
    process
    begin
    
        op <= "11";
        wait for 2 ns;
        
        op <= "00";
        wait for 2 ns;
        
        wait for 10ns;
        assert d_out = x"00" report "x = x'00'";
        
        d_in <= x"80";
        op <= "01";
        wait for 2 ns;
        assert d_out = x"80" report "x = x'80'";
        
        op <= "10";
        sh_in <= '0';
        wait for 2 ns;
        assert d_out = x"40" report "x = x'40'";
        
        op <= "00";
        wait;
    end process;

end Behavioral;

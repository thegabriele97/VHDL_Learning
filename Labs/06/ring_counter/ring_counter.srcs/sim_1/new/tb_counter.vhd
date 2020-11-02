library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_counter is
end tb_counter;

architecture Behavioral of tb_counter is

    component counter is
        generic(
            nbits: integer := 4
        );
        port(
            clk, enable, rst: in std_logic;
            r_reg: out std_logic_vector((nbits-1) downto 0)
        );
    end component;

    signal clk, enable, rst: std_logic := '0';
    signal r_reg: std_logic_vector(3 downto 0);

begin

    DUT: counter generic map(4) port map(clk, enable, rst, r_reg);
    
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
        assert r_reg = x"1" report "r_reg not 0001 after reset";
        
        enable <= '1';
        wait for 11 ns;
        assert r_reg = x"2" report "r_reg not 0010 after 11 ns";
    
        enable <= '0';
        wait;
        
    end process;


end Behavioral;

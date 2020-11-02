library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture Behavioral of tb is

    component divider is
        port(
            clk, rst: in std_logic;
            div_by: in std_logic_vector(7 downto 0);
            clk_out: out std_logic
        );
    end component;
    
    signal clk, rst, clk_out: std_logic := '0';
    signal div_by: std_logic_vector(7 downto 0);
    
begin

    dut: divider port map(clk, rst, div_by, clk_out);

    process
    begin
        
        wait for 100 ns;
        clk <= not clk;
        
    end process;
    
    process
    begin
    
        rst <= '1';
        div_by <= x"05";
        wait for 110 ns;
        
        rst <= '0';
        wait;
    
    end process;

end Behavioral;

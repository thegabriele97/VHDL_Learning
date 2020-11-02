library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_lfsr is
end tb_lfsr;

architecture Behavioral of tb_lfsr is

    component lfsr_8bit is
        port(
            rst, clk: in std_logic;
            d_out: out std_logic_vector(7 downto 0)
        );
    end component;

    signal rst, clk: std_logic := '0';
    signal d_out: std_logic_vector(7 downto 0);

begin

    DUT: lfsr_8bit port map(rst, clk, d_out);
    
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
        wait;
    
    end process;

end Behavioral;

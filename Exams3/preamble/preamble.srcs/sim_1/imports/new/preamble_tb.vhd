library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity preamble_tb is
end preamble_tb;

architecture Behavioral of preamble_tb is

    component preamble is
        port(
            start: in std_logic;
            clk, rst: in std_logic;
            data_out: out std_logic
        );
    end component;

    for DUT: preamble use entity work.preamble(hlsm);

    signal clk, rst, start, data_out: std_logic := '0';
    
begin

    DUT: preamble port map(start, clk, rst, data_out);

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
        start <= '1';
        wait for 8 ns;
        
        start <= '0';
        wait;
    
    end process;

end Behavioral;

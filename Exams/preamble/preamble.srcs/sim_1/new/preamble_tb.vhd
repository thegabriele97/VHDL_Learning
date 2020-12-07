library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity preamble_tb is
end preamble_tb;

architecture Behavioral of preamble_tb is

    component preamble is
        port(
            clk, rst, start: in std_logic;
            data_out: out std_logic
        );
    end component;

    for DUT: preamble use entity work.preamble(hlsm);

    signal clk, rst, start, data_out: std_logic := '0';
    
begin

    DUT: preamble port map(clk, rst, start, data_out);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    begin
    
        rst <= '1';
        wait for 0 ns;
        
        rst <= '0';
        start <= '1';
        wait for 10 ns;
        
        start <= '0';
        wait;
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_edgedetection is
end tb_edgedetection;

architecture Behavioral of tb_edgedetection is

    component edge_detect is
        port(
            clk, rst, stb: in std_logic;
            edge_detected: out std_logic
        );
    end component;

    for DUT: edge_detect use entity work.edge_detect(Melay);

    signal clk, rst, stb, edge_det: std_logic := '0';

begin

    DUT: edge_detect port map(clk, rst, stb, edge_det);
    
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
        wait for 2 ns;
        
        stb <= '1';
        wait for 1 ns;
        
        stb <= '0';
        wait for 1 ns;
        
        stb <= '1';
        wait for 0.5 ns;
        
        stb <= '0';
        wait for 1.5 ns;
        
        stb <= '1';
        wait for 0.1 ns;
        
        stb <= '0';
        wait for 2.2 ns;
        
        stb <= '1';
        wait for 0.01 ns;
    
        stb <= '0';
        wait;
    
    end process;
    
end Behavioral;

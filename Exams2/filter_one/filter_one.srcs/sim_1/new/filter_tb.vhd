library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity filter_tb is
end filter_tb;

architecture Behavioral of filter_tb is

    component filter_v is
        port(
            clk, rst, x: in std_logic;
            z: out std_logic
        );
    end component;

    signal clk, rst, x, z: std_logic := '0';
    signal testvector: std_logic_vector(0 to 15) := "0011101000111110";

begin

    DUT: filter_v port map(clk, rst, x, z);

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
        
        for i in testvector'range loop
            
            x <= testvector(i);
            wait for 1 ns;
            
        end loop;
    
        wait;
    
    end process;

end Behavioral;

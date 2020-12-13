library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity media_filter_tb is
end media_filter_tb;

architecture Behavioral of media_filter_tb is

    component median_filter is
        port(
            clk, rst, x: in std_logic;
            z: out std_logic
        );
    end component;

    signal clk, rst, x, z: std_logic := '0';
    type arr is array(0 to 15) of std_logic;

begin

    DUT: median_filter port map(clk, rst, x, z);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;
    
    process
        
        variable vals: arr := ('0', '1', '0', '0', '1', '0', '1', '0', '1', '1', '1', '0', '1', '0', '0', '1');
    
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 2 ns;
        
        for i in vals'range loop
            x <= vals(i);
            wait for 1 ns;
        end loop;
        
        wait;
    
    end process;

end Behavioral;

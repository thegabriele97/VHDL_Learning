library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity locker_tb is
end locker_tb;

architecture Behavioral of locker_tb is

    component locker_v is
        port(
            clk, rst, x: in std_logic;
            u: out std_logic
        );
    end component;

    signal clk, rst, x, u: std_logic := '0';

begin

    DUT: locker_v port map(clk, rst, x, u);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;
    
    process
    
        type arr is array(0 to 9) of std_logic;
        --variable vals: arr := ( '0', '1', '0', '1', '1', '0', '1', '0', '1', '0');
        variable vals: std_logic_vector(0 to 29) := "010100110101011011001000101100";
    
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        --wait for 1 ns;
        
        for i in vals'range loop
            x <= vals(i);
            wait for 1 ns;
        end loop;
    
        wait;
    
    end process;
    

end Behavioral;

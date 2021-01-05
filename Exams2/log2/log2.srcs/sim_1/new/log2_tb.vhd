library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity log2_tb is
end log2_tb;

architecture Behavioral of log2_tb is

    component log2 is
        port(
            x: in std_logic_vector(3 downto 0);
            sel: in std_logic;
            y: out std_logic_vector(2 downto 0);
            err: out std_logic
        );
    end component;

    signal x: std_logic_vector(3 downto 0);
    signal sel, err: std_logic;
    signal y: std_logic_vector(2 downto 0);

    type tb_array is array(0 to 9) of std_logic_vector(3 downto 0);
    signal testvector: tb_array := ( x"2", x"3", x"4", x"5", x"6", x"8", x"9", x"a", x"c", x"e" );
    
begin

    DUT: log2 port map(x, sel, y, err);
    
    process
    begin
    
        for i in testvector'range loop
        
            x <= testvector(i);
            sel <= '1';
            wait for 1 ns;
            
            sel <= '0';
            wait for 2 ns;
        
        end loop;
    
        wait;
    
    end process;


end Behavioral;

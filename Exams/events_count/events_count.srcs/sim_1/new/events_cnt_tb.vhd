library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity events_cnt_tb is
end events_cnt_tb;

architecture Behavioral of events_cnt_tb is

    component events_cnt is
        port(
            clk, rst, b: in std_logic;
            c: out std_logic_vector(15 downto 0) 
        );
    end component;
    
    signal clk, rst, b: std_logic := '0';
    signal c: std_logic_vector(15 downto 0);
    
begin

    DUT: events_cnt port map(clk, rst, b, c);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
        
        type arr is array(0 to 15) of std_logic;
        variable vals: arr := ('0', '1', '0', '1', '1', '1', '0', '1', '0', '1', '1', '0', '1', '0', '1', '1');
    
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        b <= '1';
        wait for 2 ns;
        
        for i in vals'range loop
            b <= vals(i);
            wait for 2 ns;
        end loop;
    
        wait;
        
    end process;

end Behavioral;

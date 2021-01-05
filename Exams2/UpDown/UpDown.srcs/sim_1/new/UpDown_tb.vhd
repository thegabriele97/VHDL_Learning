library ieee;
use ieee.std_logic_1164.all;

entity UpDown_tb is
end UpDown_tb;

architecture behav of UpDown_tb is

    component UpDown is
        port(
            clk, rst, Up, Down: in std_logic;
            Speed: out std_logic_vector(3 downto 0)
        );
    end component;    

    signal clk, rst, up, dw: std_logic := '0';
    signal speed: std_logic_vector(3 downto 0);

    signal up_tv: std_logic_vector(0 to 16) := "10111011111111111";
    signal dw_tv: std_logic_vector(0 to 16) := "00001110000001000";

begin

    DUT: UpDown port map(clk, rst, up, dw, speed);

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
        for i in up_tv'range loop
            
            up <= up_tv(i);
            dw <= dw_tv(i);
            wait for 1 ns;
            
        end loop;
        
        up <= '0';
        dw <= '0';
        wait;
    
    end process;

end behav;
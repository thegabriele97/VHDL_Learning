library ieee;
use ieee.std_logic_1164.all;

entity UpDown_tb is
end UpDown_tb;

architecture behav of UpDown_tb is

    component speeder is
        port(
            clk, rst, up, down: in std_logic;
            S: out std_logic_vector(3 downto 0)
        );
    end component;    

    for DUT: speeder use entity work.speeder(fsmd); 

    signal clk, rst, up, dw: std_logic := '0';
    signal speed: std_logic_vector(3 downto 0);

    signal up_tv: std_logic_vector(0 to 28) := "10111011111111111001111111111";
    signal dw_tv: std_logic_vector(0 to 28) := "00001110000001000111000001000";

begin

    DUT: speeder port map(clk, rst, up, dw, speed);

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
        wait for 1 ns;
        
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
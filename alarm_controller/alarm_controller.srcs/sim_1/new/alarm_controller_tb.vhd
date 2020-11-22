library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity alarm_controller_tb is
end alarm_controller_tb;

architecture Behavioral of alarm_controller_tb is

    component alarm_controller is
        port(
            clk, rst: in std_logic;
            n: in std_logic_vector(2 downto 0);
            temperature, threshold: in std_logic_vector(15 downto 0);
            alarm: out std_logic 
        );
    end component;
    
    for DUT: alarm_controller use entity work.alarm_controller(fsmd);
    
    signal clk, rst, alarm: std_logic := '0';
    signal n: std_logic_vector(2 downto 0);
    signal temperature, threshold: std_logic_vector(15 downto 0) := (others => '0');
    
begin

    DUT: alarm_controller port map(clk, rst, n, temperature, threshold, alarm);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    begin
    
        rst <= '1';
        n <= "011";
        threshold <= x"0014";
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        wait;
    
    end process;
    
    process
    begin
    
        temperature <= std_logic_vector(unsigned(temperature) + 2);
        wait for 0.1 ns;
    
    end process;


end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led_tb is
end led_tb;

architecture Behavioral of led_tb is

    component led_timer is
        port(
            clk, rst: in std_logic;
            timer_val: in std_logic_vector(31 downto 0);
            led: out std_logic
        );
    end component;
    
    for DUT: led_timer use entity work.led_timer(fsmd);
    
    signal clk, rst, led: std_logic := '0';
    signal timer_val: std_logic_vector(31 downto 0);
    
begin

    DUT: led_timer port map(clk, rst, timer_val, led);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    begin
        
        timer_val <= x"00000004";
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait;
        
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pwm_tb is
end pwm_tb;

architecture Behavioral of pwm_tb is

    component pwm is
        generic(
            nbits_pwm, nbits_divisor: integer
        );    
        port(
            clk, rst: in std_logic;
            
            divisor: in std_logic_vector((nbits_divisor-1) downto 0);
            ld_divisor: in std_logic;
            done_divisor: out std_logic;
            
            duty: in std_logic_vector((nbits_pwm-1) downto 0);
            ld_duty: in std_logic;
            done_duty: out std_logic;
            
            pwm_out: out std_logic
        );
    end component;

    signal clk, rst: std_logic := '0';
    signal divisor: std_logic_vector(31 downto 0);
    signal duty: std_logic_vector(9 downto 0);
    signal ld_div, done_div, ld_d, done_d, pwm_out: std_logic;

begin

    DUT: pwm generic map(10, 32) port map(clk, rst, divisor, ld_div, done_div, duty, ld_d, done_d, pwm_out);

    process
    begin
    
        wait for 0.25 us;
        clk <= not clk;
    
    end process;

    process
    begin
    
        rst <= '1';
        wait for 1 us;
        
        rst <= '0';
        wait for 1 us;
        
        divisor <= x"00000001";
        ld_div <= '1';
        wait until done_div = '1';
        
        ld_div <= '0';
        duty <= std_logic_vector(TO_UNSIGNED(256, duty'length));
        ld_d <= '1';
        wait until done_d = '1';
        
        ld_d <= '0';
        wait;
    
    end process;

end Behavioral;

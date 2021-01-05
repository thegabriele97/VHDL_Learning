library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pwm is
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
end pwm;

architecture Behavioral of pwm is

    component prescaler is
        generic(
            nbits: integer
        );
        port(
            clk, rst: in std_logic;
            
            nv: in std_logic_vector((nbits-1) downto 0);
            load: in std_logic;
            
            done: out std_logic := '0';
            tc: out std_logic
        );
    end component;

    component reg is
        generic(
            nbits: integer
        );
        port(
            clk, rst: in std_logic;
            
            nv: in std_logic_vector((nbits-1) downto 0);
            load: in std_logic;
            
            done: out std_logic := '0';
            val: out std_logic_vector((nbits-1) downto 0)
        );
    end component;
    
    component counter is
        generic(
            nbits: integer
        );
        port(
            clk, rst: in std_logic;
            
            en: in std_logic;
            val: out std_logic_vector((nbits-1) downto 0)
            
        );
    end component;

    signal tc: std_logic;
    signal cnt_val, reg_val: std_logic_vector((nbits_pwm-1) downto 0);

begin

    prescaler0: prescaler generic map(nbits_divisor)
        port map(clk, rst, divisor, ld_divisor, done_divisor, tc);

    counter0: counter generic map(nbits_pwm)
        port map(clk, rst, tc, cnt_val);

    reg0: reg generic map(nbits_pwm)
        port map(clk, rst, duty, ld_duty, done_duty, reg_val);

    pwm_out <= '1' when (unsigned(cnt_val) <= unsigned(reg_val)) else '0';
    
end Behavioral;

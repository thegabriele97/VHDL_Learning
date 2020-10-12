library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port(
        full_a, full_b, c_in: in std_logic;
        full_s, full_c_out: out std_logic
    );
end full_adder;

architecture full_adder_arch of full_adder is
    
    component half_adder is
        port(
            a, b: in std_logic;
            s, c_out: out std_logic
        );
    end component;
    
    signal sum_1, carry_1, carry_2: std_logic;

begin
    
    half_adder_1: half_adder port map(
        a => full_a,
        b => full_b, 
        s => sum_1,
        c_out => carry_1
    );
    
    half_adder_2: half_adder port map(
        a => c_in,
        b => sum_1,
        s => full_s,
        c_out => carry_2
    );
    
    process (carry_1, carry_2)
    begin
        
        full_c_out <= carry_1 or carry_2;
    
    end process;
     
end full_adder_arch;
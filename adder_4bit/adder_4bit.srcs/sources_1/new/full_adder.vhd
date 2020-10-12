library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    port(
        i: in std_logic_vector(1 downto 0);
        c_in: in std_logic;
        o, c_out, ripple: out std_logic
    );
end full_adder;

architecture full_adder_arch of full_adder is
begin
    
    o <= (not(i(0)) and not(i(1)) and c_in) or (not(i(0)) and i(1) and not(c_in)) or (i(0) and not(i(1)) and not(c_in)) or (i(0) and i(1) and c_in);
    c_out <= (c_in and i(1)) or (i(0) and (i(1) xor c_in));
    ripple <= (i(0) and i(1)) or (i(0) xor i(1));
    
end full_adder_arch;

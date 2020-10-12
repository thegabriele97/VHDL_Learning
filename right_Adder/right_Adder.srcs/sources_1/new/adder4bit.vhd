library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder4bit is
    port(
        a, b: in std_logic_vector(3 downto 0);
        c_in: in std_logic;
        s: out std_logic_vector(3 downto 0);
        c_out: out std_logic
    );
end adder4bit;

architecture adder4bit_arch of adder4bit is
begin

    process(a, b, c_in)
        
        variable v_a, v_b, internal_sum: unsigned(4 downto 0);
        
    begin
        
        v_a := '0' & unsigned(a);
        v_b := '0' & unsigned(b);
        internal_sum := v_a + v_b + ('0' & c_in);
        
        s <= std_logic_vector(internal_sum(3 downto 0));
        c_out <= internal_sum(4);
        
        
    end process;

end adder4bit_arch;

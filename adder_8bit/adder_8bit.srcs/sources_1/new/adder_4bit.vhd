library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder_8bit is
    port(
        a, b: in std_logic_vector(7 downto 0);
        sum: out std_logic_vector(7 downto 0);
        c_out: out std_logic
    );
end adder_8bit;

architecture Behavioral of adder_8bit is
begin

    process(a, b)
    
        variable v_a, v_b: unsigned(8 downto 0);
        variable v_sum: unsigned(8 downto 0);
    
    begin
    
        v_a := '0' & unsigned(a);
        v_b := '0' & unsigned(b);
        v_sum := v_a - v_b;
        
        sum <= std_logic_vector(v_sum(7 downto 0));
        c_out <= v_sum(8);
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder_Nbit is
    generic(
        n: integer := 4
    );
    port(
        a, b: in std_logic_vector(n-1 downto 0);
        c_in: in std_logic;
        sum: out std_logic_vector(n-1 downto 0);
        c_out, overflow: out std_logic
    );
end adder_Nbit;

architecture Behavioral of adder_Nbit is
begin

    process(a, b, c_in)
        
        variable v_sum: unsigned(n downto 0);
        variable c_in_nto1: std_logic;
    
    begin
    
        v_sum := ('0' & unsigned(a)) + ('0' & unsigned(b)) + ('0' & c_in);
        c_in_nto1 := a(n-1) xor b(n-1) xor v_sum(n-1);
        
        overflow <= v_sum(n) xor c_in_nto1;
        c_out <= v_sum(n);
        sum <= std_logic_vector(v_sum(n-1 downto 0));
    
    end process;

end Behavioral;

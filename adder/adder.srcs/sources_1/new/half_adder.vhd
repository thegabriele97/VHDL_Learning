library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    port(
        a, b: in std_logic;
        s, c_out: out std_logic
    );
end half_adder;

architecture half_adder_arch of half_adder is
begin
    
    process(a, b)
    begin
    
        s <= a xor b;
        
        if a = '1' and b = '1' then
            c_out <= '1';
        else
            c_out <= '0';
        end if;
    
    end process;

end half_adder_arch;
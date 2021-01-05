library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_gate is
    generic(
        n_in: integer
    );
    port(
        a: in std_logic_vector((n_in-1) downto 0);
        y: out std_logic
    );
end or_gate;

architecture Behavioral of or_gate is
    
    signal tmp: std_logic_vector((n_in-1) downto 0);

begin
    
    and_gen: for i in 0 to (n_in-1) generate
    
        first_and: if (i = 0) generate
            tmp(1) <= a(i) or a(i + 1); 
        end generate;
        
        oth: if (i > 1) generate
            tmp(i) <= tmp(i-1) or a(i);
        end generate;
        
    end generate;
    
    y <= tmp(n_in-1);

end Behavioral;

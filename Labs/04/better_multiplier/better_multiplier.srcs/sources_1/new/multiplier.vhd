library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity multiplier is
    generic(
        nbits: integer := 4
    );
    port(
        a, b: in std_logic_vector((nbits-1) downto 0);
        y: out std_logic_vector((2*nbits-1) downto 0)
    );
end multiplier;

architecture Behavioral of multiplier is
begin

    process(a, b)
    
        variable mask: std_logic_vector((nbits-1) downto 0);
        variable mul_res: std_logic_vector((nbits-1) downto 0);
        variable storage: std_logic_vector(nbits downto 0);
        variable result: std_logic_vector((2*nbits-1) downto 0);
    
    begin
    
        storage := (others => '0');
        for i in 0 to (nbits-1) loop
            
            mask := (others => b(i));
            mul_res := mask and a;
            storage := std_logic_vector(unsigned(storage) + unsigned(mul_res));
            
            result((nbits+i) downto i) := storage(nbits downto 0); 
            
            storage := std_logic_vector(shift_right(unsigned(storage), 1));
            
        end loop;
        
        y <= result;
        
    end process;

end Behavioral;

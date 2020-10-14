library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder_nbits is
    generic(
        nbits: integer := 4
    );
    port(
        a, b: in std_logic_vector((nbits-1) downto 0);
        sum: out std_logic_vector((nbits-1) downto 0);
        c_out: out std_logic
    );
end adder_nbits;

architecture Behavioral of adder_nbits is
begin

    process(a, b)
    
        variable total: unsigned(nbits downto 0);
    
    begin
    
        total := unsigned('0' & a) + unsigned('0' & b);
        
        sum <= std_logic_vector(total((nbits-1) downto 0));
        c_out <= total(nbits);
    
    end process;

end Behavioral;

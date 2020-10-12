library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder_3bit is
    port(
        a, b: in std_logic_vector(2 downto 0);
        sum: out std_logic_vector(2 downto 0);
        c_out: out std_logic
    );
end adder_3bit;

architecture Behavioral of adder_3bit is
begin

    process(a, b)
    
        variable total: unsigned(3 downto 0);
    
    begin
    
        total := ('0' & unsigned(a)) + ('0' & unsigned(b));
        
        sum <= std_logic_vector(total(2 downto 0));
        c_out <= total(3);
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity converter is
    port(
        i: in std_logic_vector(7 downto 0);
        o: out std_logic_vector(3 downto 0);
        c_out: out std_logic
    );
end converter;

architecture Behavioral of converter is
begin

    process(i)
        
        variable a, b: unsigned(4 downto 0);
        variable output: unsigned(4 downto 0);
        
    begin
    
        a := '0' & unsigned(i(3 downto 0));
        b := '0' & unsigned(i(7 downto 4));
        output := a - b;
        
        o <= std_logic_vector(output(3 downto 0));
        c_out <= output(4);
    
    end process;

end Behavioral;

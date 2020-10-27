library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity therm2bin is
    generic(
        nbits_in: integer := 7;
        nbits_out: integer := 3 
    );    
    port(
        therm: in std_logic_vector((nbits_in-1) downto 0);
        bin: out std_logic_vector((nbits_out-1) downto 0)
    );
end therm2bin;

architecture Behavioral of therm2bin is
begin

    process(therm)
    
        variable found: boolean;
    
    begin
        
        found := false;    
        for i in (nbits_in-1) downto 0 loop
            if (not(found) and therm(i) = '1') then
                found := true;
                bin <= std_logic_vector(to_unsigned(i+1, nbits_out));
            end if;
        end loop;
        
        if (not(found)) then
            bin <= (others => '0');
        end if;
    
    end process;

end Behavioral;

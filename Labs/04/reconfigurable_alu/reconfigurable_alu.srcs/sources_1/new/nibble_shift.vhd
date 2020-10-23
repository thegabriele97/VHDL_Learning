library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nibble_shift is
    port(
        nibble: in std_logic_vector(3 downto 0);
        d_in: in std_logic_vector(15 downto 0);
        d_out: out std_logic_vector(15 downto 0)
    );
end nibble_shift;

architecture Behavioral of nibble_shift is
begin

    process(nibble, d_in)
    
        variable int_data: std_logic_vector(15 downto 0) := (others => '0');
        variable index: integer;
    
    begin
    
        index := 0;
        for i in 0 to 3 loop
            if (nibble(i) = '1') then
                
                int_data(index+3 downto index) := d_in((i*4+3) downto (i*4)); 
                index := index + 4;
                
            end if;
        end loop;
    
        d_out <= int_data;
        
    end process;

end Behavioral;

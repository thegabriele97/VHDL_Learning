library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity barrel_shifter is
    port(
        d_in: in std_logic_vector(7 downto 0);
        lar: in std_logic_vector(1 downto 0);
        amt: in std_logic_vector(2 downto 0);
        d_out: out std_logic_vector(7 downto 0)
    );
end barrel_shifter;

architecture Behavioral of barrel_shifter is
begin

    process(d_in, lar, amt)
   
        variable shift_amt: integer;   -- the integer value of shifts to do
        variable data: std_logic_vector(7 downto 0);
    
    begin
    
        shift_amt := TO_INTEGER(unsigned(amt));
        data((7-shift_amt) downto 0) := d_in(7 downto shift_amt); --higher bits of the original data as lower part of data out
        
        case lar is
            when "00" =>
                data(7 downto (7-shift_amt+1)) := (others => '0');
                
            when "01" =>
                data(7 downto (7-shift_amt+1)) := (others => d_in(7));
                
            when others =>
                if (shift_amt > 0) then
                    data(7 downto (7-shift_amt+1)) := d_in((shift_amt-1) downto 0); --rotation: lower bits of original data as higher part of data out
                end if;
        end case;
        
        d_out <= data;
    
    end process;

end Behavioral;

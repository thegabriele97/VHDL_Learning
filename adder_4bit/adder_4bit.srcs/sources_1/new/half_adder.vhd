library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    port(
        i: in std_logic_vector(1 downto 0);
        o, c_out: out std_logic
    );    
end half_adder;

architecture half_adder_arch of half_adder is
begin

    process(i)
    begin
        c_out <= '0';
        
        if i = "00" or i = "11" then
            if i = "11" then
                c_out <= '1';
            end if;
            
            o <= '0';
        elsif i = "01" or i = "10" then
            o <= '1';
        end if;   
           
    end process;

end half_adder_arch;

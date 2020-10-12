library ieee;
use ieee.std_logic_1164.all;

entity mpx4x2 is
    port(
        i: in std_logic_vector(3 downto 0);
        s: in std_logic_vector(1 downto 0);
        ce: in std_logic; -- chip enable (high active). When 0, O is Z
        o: out std_logic
    );
end mpx4x2;

architecture mpx4x2_arch of mpx4x2 is
begin

    process(s)
    begin
        
        if ce = '1' then
            if s = "00" then
                o <= i(0);
            elsif s = "01" then
                o <= i(1);
            elsif s = "10" then
                o <= i(2);
            elsif s = "11" then
                o <= i(3);
            end if;
        end if;
                
    end process;
    
    process(ce)
    begin
    
        if ce = '0' then
            o <= 'Z';
        end if;
    
    end process;

end mpx4x2_arch;
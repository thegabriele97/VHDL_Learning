library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_1s_2bit is
    port(
        d: in std_logic_vector(1 downto 0);
        o: out std_logic_vector(1 downto 0)
    );
end counter_1s_2bit;

architecture counter_1s_2bit_arch of counter_1s_2bit is
begin

    process(d)
    begin
        
        if d = "11" then
            o <= "10";
        elsif d = "10" or d = "01" then
            o <= "01";
        else
            o <= "00";
        end if;
    
    end process;

end counter_1s_2bit_arch;

library ieee;
use ieee.std_logic_1164.all;

entity reg8bit is
    port(
        d_in: in std_logic_vector(7 downto 0);
        d_out: out std_logic_vector(7 downto 0);
        oe: in std_logic; -- Output Enable. 0 for High Impedance
        load: in std_logic -- Load data in memory
    );
end reg8bit;

architecture reg8bit_arch of reg8bit is
    
    signal mem: std_logic_vector(7 downto 0);
    
begin

    process(oe)
    begin
        
        if oe = '1' then
            d_out <= mem;
        elsif oe = '0' then
            d_out <= "ZZZZZZZZ";
        end if;
        
    end process;

    process(load)
    begin
        
        if (load = '1') then
            mem <= d_in;
        end if;
    
    end process;

end reg8bit_arch;

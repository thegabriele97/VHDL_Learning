library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_2bit is
    port(
        a, b: in std_logic_vector(1 downto 0);
        sum: out std_logic_vector(1 downto 0);
        c_out: out std_logic
    );
end adder_2bit;

architecture Behav_adder_2bit of adder_2bit is
begin

    process(a, b)
    
        variable total: unsigned(2 downto 0);
        
    begin
    
        total := ('0' & unsigned(a)) + ('0' & unsigned(b));
    
        sum <= std_logic_vector(total(1 downto 0));
        c_out <= total(2);
    
    end process;

end Behav_adder_2bit;
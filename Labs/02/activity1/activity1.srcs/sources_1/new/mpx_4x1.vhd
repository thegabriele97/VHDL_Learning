library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mpx_4x1 is
    port(
        d: in std_logic_vector(3 downto 0);
        s: in std_logic_vector(1 downto 0);
        y: out std_logic
    );
end mpx_4x1;

architecture Behavioral of mpx_4x1 is
begin

    process(d, s)
    begin
    
        case s is
        
            when "00" =>
                y <= d(0);
            when "01" =>
                y <= d(1);
            when "10" =>
                y <= d(2);
            when "11" =>
                y <= d(3);
            when others =>
                y <= 'X';
        
        end case;
    
    end process;

end Behavioral;

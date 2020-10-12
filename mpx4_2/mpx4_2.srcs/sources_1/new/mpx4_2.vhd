library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mpx4_2 is
    port(
        i: in std_logic_vector(3 downto 0);
        s: in std_logic_vector(1 downto 0);
        cs: in std_logic;
        o: out std_logic
    );
end mpx4_2;

architecture Behavioral of mpx4_2 is
begin

    process(i, s, cs)
    begin
    
        case cs is
            when '0' => 
                o <= 'Z';
            when '1' => 
                
                case s is
                    when "00" => 
                        o <= i(0);
                    when "01" =>
                        o <= i(1);
                    when "10" =>
                        o <= i(2);
                    when "11" =>
                        o <= i(3);
                    when others =>
                        o <= 'U';
                end case;
            
            when others =>
                o <= 'U';     
        end case;
        
    end process;

end Behavioral;

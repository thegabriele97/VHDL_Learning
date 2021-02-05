library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity device is
    port(
        m: in std_logic_vector(2 downto 0);
        A: out std_logic
    );
end device;

architecture if_then of device is
begin
    
    process(m)
    begin
    
        if (m = "001" or m = "010" or m = "100") then
            A <= '0';
        else
            A <= '1';
        end if;
    
    end process;

end if_then;

architecture case_when of device is
begin
    
    process(m)
    begin
    
        case m is 
        
            when "001" => A <= '0';
            when "010" => A <= '0';
            when "100" => A <= '0';
            when others => A <= '1';
        
        end case;
    
    end process;

end case_when;

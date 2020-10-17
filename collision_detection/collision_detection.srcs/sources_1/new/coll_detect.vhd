library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity coll_detect is
    port(
        m: in std_logic_vector(3 downto 0);
        c: out std_logic
    );
end coll_detect;

architecture Beh_IfThen of coll_detect is
begin

    process(m)
        variable total_ones: unsigned(2 downto 0);
    begin
    
        total_ones := ("00" & m(0)) + ('0' & m(1)) +
                       ('0' & m(2)) + ('0' & m(3));  
    
        if (total_ones > 1) then
            c <= '1';
        else
            c <= '0';
        end if;
        
    end process;

end Beh_IfThen;

architecture Behav_Case of coll_detect is
begin

    process(m)
    begin
    
        case m is
            when "0000" | "0001" | "0010" | "0100" | "1000" =>
                c <= '0';
            when others =>
                c <= '1';
         end case;
    
    end process;

end Behav_Case;

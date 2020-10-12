library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoderw_priority is
    port(
        req: in std_logic_vector(3 downto 0);
        code: out std_logic_vector(1 downto 0);
        active: out std_logic
    );
end encoderw_priority;

architecture Behav_Case of encoderw_priority is
begin

    process(req)
    begin
    
        case req is
            when "1---" =>
                code <= "11";
            when "01--" =>
                code <= "10";
            when "001-" =>
                code <= "01";
            when "0001" | "0000" =>
                code <= "00";
            when others =>
                code <= "XX";
        end case;
        
        case req is
            when "0000" =>
                active <= '0';
            when others =>
                active <= '1';
        end case;
    
    end process;

end Behav_Case;

architecture Behav_IfThenElse of encoderw_priority is
begin

    process(req)
    begin
    
        if req /= "0000" then
            active <= '1';
            
            if req(3) = '1' then
                code <= "11";
            elsif req(2) = '1' then
                code <= "10";
            elsif req(1) = '1' then
                code <= "01";
            elsif req(0) = '1' then
                code <= "00";
            end if;
            
        else
            active <= '0';
            code <= "00";
        end if;
    
    end process;

end Behav_IfThenElse; 

architecture DataFlow_WithSelect of encoderw_priority is
begin

    with req select
        code <= "11" when "1---",
                "10" when "01--",
                "01" when "001-",
                "00" when "0001" | "0000",
                "XX" when others;
                
    with req select
        active <= '0' when "0000",
                  '1' when others; 

end DataFlow_WithSelect;

architecture DataFlow_WhenElse of encoderw_priority is
begin

    code <= "11" when req(3) = '1' else
            "10" when req(2) = '1' else
            "01" when req(1) = '1' else
            "00" when req(0) = '1' or req = "0000";
    
    active <= '1' when req /= "0000" else
              '0';

end DataFlow_WhenElse;

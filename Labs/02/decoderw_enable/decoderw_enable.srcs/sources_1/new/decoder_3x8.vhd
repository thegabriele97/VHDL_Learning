library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_3x8 is
    port(
        i: in std_logic_vector(2 downto 0);
        cs: in std_logic;
        s: out std_logic_vector(7 downto 0)
    );
end decoder_3x8;

architecture Behav_Case of decoder_3x8 is
begin
    
    process(cs, i)
    begin
        
        case cs & i is
            when "1000" =>
                s <= "00000001";
            when "1001" =>
                s <= "00000010";
            when "1010" =>
                s <= "00000100";
            when "1011" =>
                s <= "00001000";
            when "1100" =>
                s <= "00010000";
            when "1101" => 
                s <= "00100000";
            when "1110" =>
                s <= "01000000";
            when "1111" =>
                s <= "10000000";
            when others =>
                s <= "00000000";
         end case;
        
    end process;

end Behav_Case;

architecture Behav_IfThenElse of decoder_3x8 is
begin

    process(i, cs)
    begin
    
        if cs = '0' then    
            s <= "00000000";
        elsif cs = '1' then
        
            if i = "000" then
                s <= "00000001";
            elsif i = "001" then
                s <= "00000010";
            elsif i = "010" then
                s <= "00000100";
            elsif i = "011" then
                s <= "00001000";
            elsif i = "100" then
                s <= "00010000";
            elsif i = "101" then
                s <= "00100000";
            elsif i = "110" then
                s <= "01000000";
            elsif i = "111" then
                s <= "10000000";
            end if; 
            
        end if;
    
    end process;

end Behav_IfThenElse;

architecture DataFlow_SelectWhen of decoder_3x8 is
begin
    
    with cs & i select
        s <= "00000001" when "1000",
             "00000010" when "1001",
             "00000100" when "1010",
             "00001000" when "1011",
             "00010000" when "1100",
             "00100000" when "1101",
             "01000000" when "1110",
             "10000000" when "1111",
             "00000000" when others;

end DataFlow_SelectWhen;

architecture DataFlow_WhenElse of decoder_3x8 is
begin

    s <= "00000000" when cs = '0'   else
         "00000001" when i  = "000" else
         "00000010" when i  = "001" else
         "00000100" when i  = "010" else
         "00001000" when i  = "011" else
         "00010000" when i  = "100" else
         "00100000" when i  = "101" else
         "01000000" when i  = "110" else
         "10000000" when i  = "111";

end DataFlow_WhenElse;

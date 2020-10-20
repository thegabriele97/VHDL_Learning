library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity multiplier is
    port(
        a, b: in std_logic_vector(7 downto 0);
        y: out std_logic_vector(15 downto 0)
    );
end multiplier;

architecture Behavioral of multiplier is
begin

    process(a, b)
    
        variable res1, res2, res3, res4, res5, res6, res7, res8: std_logic_vector(15 downto 0);
        variable temp_op: std_logic_vector(7 downto 0);
    
    begin
    
        temp_op := (others => b(0));
        res1 := x"00" & (a and temp_op);
        
        temp_op := (others => b(1));
        res2 := "0000000" & (a and temp_op) & '0';
    
        temp_op := (others => b(2));
        res3 := "000000" & (a and temp_op) & "00";
    
        temp_op := (others => b(3));
        res4 := "00000" & (a and temp_op) & "000";
        
        temp_op := (others => b(4));
        res5 := "0000" & (a and temp_op) & "0000";
        
        temp_op := (others => b(5));
        res6 := "000" & (a and temp_op) & "00000";
        
        temp_op := (others => b(6));
        res7 := "00" & (a and temp_op) & "000000";
        
        temp_op := (others => b(7));
        res8 := "0" & (a and temp_op) & "0000000";
    
        y <= std_logic_vector(unsigned(res1) + unsigned(res2) + unsigned(res3) + unsigned(res4)
                            + unsigned(res5) + unsigned(res6) + unsigned(res7) + unsigned(res8));
    
    end process;

end Behavioral;

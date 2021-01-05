library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_std.all;

entity log2 is
    port(
        x: in std_logic_vector(3 downto 0);
        sel: in std_logic;
        y: out std_logic_vector(2 downto 0);
        err: out std_logic
    );
end log2;

architecture if_then of log2 is
begin

    process(x, sel)
    begin
    
        err <= '0';
        y <= "000";
    
        if (sel = '1' and x(3) = '1') then
            y <= "011";
        elsif (sel = '1' and x(2) = '1') then
            y <= "010";
        elsif (sel = '1' and x(1) = '1') then
            y <= "001";
        elsif (sel = '1' and x(0) = '1') then
            y <= "000";
        elsif (sel = '1' and x = x"0") then
            err <= '1';
        elsif (sel = '0' and x = x"8") then
            y <= "011";
        elsif (sel = '0' and x(3) = '1') then
            y <= "100";
        elsif (sel = '0' and x = x"4") then
            y <= "010";
        elsif (sel = '0' and x(2) = '1') then
            y <= "011";
        elsif (sel = '0' and x = x"2") then
            y <= "001";
        elsif (sel = '0' and x(1) = '1') then
            y <= "010";
        elsif (sel = '0' and x = x"1") then
            y <= "000";
        elsif (sel = '0') then
            err <= '1';
        end if;
    
    end process;

end if_then;

architecture case_when of log2 is

    signal cmd: std_logic_vector(4 downto 0);
    
begin

    process(x, sel)
    
        variable cmd: std_logic_vector(4 downto 0) := sel & x;
    
    begin
    
        case cmd is
        
            when "11000" =>
        
        end case;
    
    end process;

end case_when;

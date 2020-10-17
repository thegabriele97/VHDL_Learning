library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenseg_controller is
    port(
        d: in std_logic_vector(3 downto 0);
        dot_enable: in std_logic;
        segment: out std_logic_vector(7 downto 0) 
    );
end sevenseg_controller;

architecture Behavioral of sevenseg_controller is
begin
    
    with d select
        segment(6 downto 0) <= "1111110" when "000",
                               "0110000" when "001",
                               "1101101" when "010",
                               "1111001" when "011",
                               "0010011" when "100",
                               "1101100" when "101",
                               "0011111" when "110",
                               "1110010" when "111",
                               "1111111" when others;
                               
    segment(7) <= dot_enable;
    
end Behavioral;

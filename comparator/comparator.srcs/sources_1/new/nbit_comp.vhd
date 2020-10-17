----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2020 16:42:48
-- Design Name: 
-- Module Name: nbit_comp - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity nbit_comp is
    generic(
        n: integer := 4
    );
    port(
        a, b: in std_logic_vector(n-1 downto 0);
        gt, eq, lt: out std_logic
    );
end nbit_comp;

architecture Behavioral of nbit_comp is
begin

    process(a, b)
    
        variable out_code: std_logic_vector(2 downto 0);
        variable v_a: signed(n-1 downto 0);
        variable v_b: signed(n-1 downto 0);
        
    begin
    
        v_a := signed(a);
        v_b := signed(b);
    
        if (v_a < v_b) then
            out_code := "001";
        elsif (v_a = v_b) then
            out_code := "010";
        elsif (v_a > v_b) then
            out_code := "110";
        end if;
    
    end process;

end Behavioral;

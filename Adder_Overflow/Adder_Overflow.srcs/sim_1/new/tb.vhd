----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2020 15:23:22
-- Design Name: 
-- Module Name: tb - Behavioral
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

entity tb is
end tb;

architecture Behavioral of tb is

    component adder_Nbit is
        generic(
            n: integer := 4
        );
        port(
            a, b: in std_logic_vector(n-1 downto 0);
            c_in: in std_logic;
            sum: out std_logic_vector(n-1 downto 0);
            c_out, overflow: out std_logic
        );
    end component;
    
    signal a_s, b_s, sum_s: std_logic_vector(3 downto 0);
    signal c_in_s, c_out_s, of_s: std_logic;

begin

    adder_4bit: adder_Nbit generic map(n => 4) port map(
        a => a_s,
        b => b_s,
        c_in => c_in_s,
        sum => sum_s,
        c_out => c_out_s,
        overflow => of_s 
    );
    
    process
    begin
    
        a_s <= "0111";
        b_s <= "0001";
        c_in_s <= '0';
        wait;
        
    end process;

end Behavioral;

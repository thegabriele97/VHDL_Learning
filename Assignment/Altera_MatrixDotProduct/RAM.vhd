----------------------------------------------------------------------------------
-- Company:     Politecnico di Torino
-- Engineer:    La Greca Salvatore Gabriele
-- 
-- Create Date: 14.12.2020 17:07:15
-- Design Name: Random Access Memory
-- Module Name: RAM
-- Project Name: Matrix Dot Product
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity RAM is
    generic(
        k, n: integer
    );
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        
        rw          : in std_logic;
        oe          : in std_logic;
        cs          : in std_logic;
        
        addr        : in std_logic_vector((k-1) downto 0);
        data        : inout std_logic_vector((n-1) downto 0)
    );
end RAM;

architecture Behavioral of RAM is


	
begin

	RAM_Internal: ram_altera port map(aclr, address, clk, data_in, rden, wren, data_out);

	
	aclr <= rst;
	
	wren <= '1' when (rst = '0' and cs = '1' and rw = '0') else '0';
	rden <= '1' when (rw = '1' and oe = '1' and cs = '1')  else '0';
	
	data_in <= data;
	data <= data_out when (rw = '1' and oe = '1' and cs = '1') else (others => 'Z');
	
end Behavioral;

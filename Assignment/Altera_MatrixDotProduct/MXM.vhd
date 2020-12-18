----------------------------------------------------------------------------------
-- Company:     Politecnico di Torino
-- Engineer:    La Greca Salvatore Gabriele
-- 
-- Create Date: 14.12.2020 17:17:29
-- Design Name: Matrix Memory
-- Module Name: MXM
-- Project Name: Matrix Dot Product
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MXM is
    generic(
        r           : integer;
        c           : integer;
        w           : integer
    );
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        
        rw          : in std_logic;
        oe          : in std_logic;
        cs          : in std_logic;
        
        row         : in std_logic_vector((r-1) downto 0);
        col         : in std_logic_vector((c-1) downto 0);
        data        : inout std_logic_vector((w-1) downto 0)
    );
end MXM;

architecture structural of MXM is

	component ram_mxm_altera_mod IS
		PORT
		(
			aclr		: IN STD_LOGIC  := '0';
			address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			rden		: IN STD_LOGIC  := '1';
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END component;

   signal enable, cselect: std_logic_vector((2**c-1) downto 0);
	signal addr: std_logic_vector(9 downto 0);
	signal data_in, data_out: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal rden, wren: std_LOGIC;
	
begin

	RamMatrixAltera: ram_mxm_altera_mod port map(rst, addr, clk, data_in, rden, wren, data_out);

	addr <= row & col;
	
	data <= data_out when (cs = '1' and rw = '1' and oe = '1') else (others => 'Z');
	data_in <= data;
	
	rden <= rw;
	wren <= not rw;

end structural;

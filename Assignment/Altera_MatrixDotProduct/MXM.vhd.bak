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

    component RAM is
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
    end component;

    signal enable, cselect: std_logic_vector((2**c-1) downto 0);

begin

    matrix_gen: for i in 0 to (2**c-1) generate
        RAM_i: RAM generic map(r, w) port map(clk, rst, rw, enable(i), cselect(i), row, data);
    end generate; 

    process(col, oe, rst, cs)
    begin
    
        enable <= (others => '0');
        enable(TO_INTEGER(unsigned(col))) <= oe;
        
        cselect <= (others => '0');
        if (rst = '1') then
            cselect <= (others => '1'); -- we want to reset everything
        else
            cselect(TO_INTEGER(unsigned(col))) <= cs;
        end if;
        
    end process;

end structural;

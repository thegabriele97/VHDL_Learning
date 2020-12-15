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

    type mem_type is array(0 to 2**k-1) of std_logic_vector((n-1) downto 0);
    signal memory: mem_type;

begin

    wr_proc: process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (cs = '1') then
                if (rst = '1') then
                    memory <= (others => (others => '0'));
                elsif (rw = '0') then
                    memory(TO_INTEGER(unsigned(addr))) <= data;
                end if;
            end if;
        end if;
    
    end process;
    
    data <= memory(TO_INTEGER(unsigned(addr))) when (rw = '1' and oe = '1' and cs = '1') else (others => 'Z');
    
--    process(rw, oe, addr)
--    begin
    
--        if (rw = '1' and oe = '1' and cs = '1') then
--            data <= memory(TO_INTEGER(unsigned(addr)));
--        else
--            data <= (others => 'Z');
--        end if;
    
--    end process;    
   

end Behavioral;

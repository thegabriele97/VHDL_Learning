library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity regfile is
    generic(
        nbits: integer := 32;
        nregs_pow2: integer := 2
    );
    port(
        we, re, clk, rst: in std_logic;
        waddr, raddr: in std_logic_vector((nregs_pow2-1) downto 0);
        wdata: in std_logic_vector((nbits-1) downto 0);
        rdata: out std_logic_vector((nbits-1) downto 0)
    );
end regfile;

architecture Behavioral of regfile is
    
    constant nregs: integer := 2**nregs_pow2;
    type regfileType is array(0 to (nregs-1)) of std_logic_vector((nbits-1) downto 0);
    signal regs: regfileType;

begin

    process(clk, rst, we, waddr, wdata)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
            
                for i in 0 to (nregs-1) loop
                    regs(i) <= (others => '0');
                end loop;
            
            elsif (we = '1') then
            
                regs(TO_INTEGER(unsigned(waddr))) <= wdata;
            
            end if;
            
        end if;
    
    end process;
    
    rdata <= regs(TO_INTEGER(unsigned(raddr))) when (re = '1') else
             (others => 'Z');

end Behavioral;

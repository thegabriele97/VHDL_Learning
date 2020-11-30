library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ReplPtr is
    generic(
        m: integer
    );
    port(
        clk, rst, en_replptr: in std_logic;
        wr_wordline: out std_logic_vector((2**m-1) downto 0)
    );
end ReplPtr;

architecture Behavioral of ReplPtr is

    signal curr_ptr, next_ptr: std_logic_vector((m-1) downto 0);

begin

    process(curr_ptr, en_replptr)
    begin
    
        next_ptr <= curr_ptr;
        if (en_replptr = '1') then
            next_ptr <= std_logic_vector(unsigned(curr_ptr) + 1);
        end if;    

        wr_wordline <= (others => '0');
        if (en_replptr = '1') then
            wr_wordline(TO_INTEGER(unsigned(curr_ptr))) <= '1';
        end if;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_ptr <= (others => '0');
            else
                curr_ptr <= next_ptr;
            end if;
        end if;
        
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ringcounter is
    generic(
        nbits: integer := 4
    );
    port(
        clk, enable, rst: in std_logic;
        r_reg: out std_logic_vector((nbits-1) downto 0)
    );
end ringcounter;

architecture Behav2 of ringcounter is 

    signal int_mem: std_logic_vector((nbits-1) downto 0);

begin

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                int_mem((nbits-1) downto 1) <= (others => '1');
                int_mem(0) <= '0';
            elsif (enable = '1') then
                int_mem((nbits-2) downto 0) <= int_mem((nbits-1) downto 1);
                
                if (TO_INTEGER(unsigned(int_mem((nbits-1) downto 1))) = 0) then
                    int_mem(nbits-1) <= '1';
                --elsif (TO_INTEGER(unsigned(int_mem((nbits-1) downto 1))) /= (2**(nbits-1) - 1)) then
                else
                    int_mem(nbits-1) <= '0';
                end if; 
                
            end if;
        end if;
    
    end process;
    
    r_reg <= int_mem;

end Behav2;

architecture Behavioral of ringcounter is

    signal curr_state, next_state: std_logic_vector((nbits-1) downto 0);

begin

    process(clk, enable, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state((nbits-1) downto 1) <= (others => '1');
                curr_state(0) <= '0';
            elsif (enable = '1') then
                curr_state <= next_state;
            end if;
        end if;
    
    end process;
    
    next_state((nbits-2) downto 0) <= curr_state((nbits-1) downto 1);
    next_state(nbits-1) <= '1' when (TO_INTEGER(unsigned(curr_state((nbits-1) downto 1))) = 0) else '0';
    
    r_reg <= curr_state;

end Behavioral;

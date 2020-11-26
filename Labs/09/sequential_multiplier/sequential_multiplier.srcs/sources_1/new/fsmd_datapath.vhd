library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsmd_datapath is
    port(
        clk, rst: in std_logic;
        
        --Data input
        a, b: in std_logic_vector(7 downto 0);
        
        --Control & Status signals
        ld_a, ld_b, ld_p: in std_logic;
        shl_a, shr_b: in std_logic;
        en_p: in std_logic;
        
        tc_b, b0_1: out std_logic;
        
        --Data output
        p: out std_logic_vector(15 downto 0)
    );
end fsmd_datapath;

architecture Behavioral of fsmd_datapath is

    signal curr_a, next_a, curr_b, next_b, curr_p, next_p: std_logic_vector(15 downto 0);

begin

    tc_b <= '1' when (TO_INTEGER(unsigned(curr_b)) = 0) else '0';
    p <= curr_p;

    process(a, b, ld_a, ld_b, ld_p, shl_a, shr_b, en_p, curr_a, curr_b, curr_p)
    begin
    
        --A register
        next_a <= curr_a;   
        
        if (ld_a = '1') then
            next_a <= x"00" & a;
        elsif (shl_a = '1') then
            next_a <= curr_a(14 downto 0) & '0';
        end if;
        
        --B register
        next_b <= curr_b;
        b0_1 <= curr_b(0);
        
        if (ld_b = '1') then
            next_b <= x"00" & b;
        elsif (shr_b = '1') then
            next_b <= '0' & curr_b(15 downto 1);
        end if;
    
        --P register
        next_p <= curr_p;
        
        if (ld_p = '1') then
            next_p <= (others => '0');
        elsif (en_p = '1') then
            next_p <= std_logic_vector(unsigned(curr_a) + unsigned(curr_p));
        end if;
    
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_a <= (others => '0');
                curr_b <= (others => '0');
                curr_p <= (others => '0');
            else
                curr_a <= next_a;
                curr_b <= next_b;
                curr_p <= next_p;
            end if;
        end if;
    
    end process;

end Behavioral;

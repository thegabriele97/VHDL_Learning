library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lfsr_8bit is
    port(
        rst, clk: in std_logic;
        d_out: out std_logic_vector(7 downto 0)
    );
end lfsr_8bit;

architecture Behavioral of lfsr_8bit is

    signal int_mem: std_logic_vector(7 downto 0);

begin

    process(clk, rst)
    begin
    
        if (rst = '1') then
            int_mem <= x"da";
        elsif (rising_edge(clk)) then
        
            int_mem(6 downto 0) <= int_mem(7 downto 1);
            int_mem(7) <= int_mem(4) xor int_mem(3) xor int_mem(2) xor int_mem(0);
        
        end if;
    
    end process;
    
    d_out <= int_mem;

end Behavioral;

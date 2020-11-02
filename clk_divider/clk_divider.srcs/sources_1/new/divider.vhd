library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity divider is
    port(
        clk, rst: in std_logic;
        div_by: in std_logic_vector(7 downto 0);
        clk_out: out std_logic
    );
end divider;

architecture Behavioral of divider is
    
    signal int_counter: std_logic_vector(7 downto 0);
    
begin

    process(clk, rst, int_counter)
    begin
    
        if(rising_edge(clk)) then
        
            if (rst = '1' or int_counter = x"00") then
                int_counter <= std_logic_vector(unsigned(div_by) - 1);
            else
                int_counter <= std_logic_vector(unsigned(int_counter) - 1);
            end if;
            
        end if;
    
    end process;
    
    clk_out <= '1' when (int_counter = x"00") else '0';

end Behavioral;

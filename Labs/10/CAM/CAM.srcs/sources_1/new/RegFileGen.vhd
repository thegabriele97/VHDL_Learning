library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity RegFileGen is
    generic(
        m, n: integer
    );
    port(
        clk, rst, w_en: in std_logic;
        w_addr, r_addr: in std_logic_vector((m-1) downto 0);
        w_data: in std_logic_vector((n-1) downto 0);
        r_data: out std_logic_vector((n-1) downto 0)
    );
end RegFileGen;

architecture Behavioral of RegFileGen is

    type regfile_type is array(0 to (2**m-1)) of std_logic_vector((n-1) downto 0);
    signal memory: regfile_type;

begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                for i in 0 to 2**m-1 loop
                    memory(i) <= (others => '0');
                end loop;
            elsif (w_en = '1') then
                memory(TO_INTEGER(unsigned(w_addr))) <= w_data;
            end if;
        end if;
    
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            r_data <= memory(TO_INTEGER(unsigned(r_addr)));
        end if;
    
    end process;

end Behavioral;

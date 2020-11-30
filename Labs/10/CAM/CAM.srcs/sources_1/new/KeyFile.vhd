library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity KeyFile is
    generic(
        m, n: integer
    );
    port(
        clk, rst: in std_logic;
        key_in: in std_logic_vector((n-1) downto 0);
        ld: in std_logic_vector((2**m-1) downto 0);
        addr: out std_logic_vector((m-1) downto 0);
        hit: out std_logic
    );
end KeyFile;

architecture Behavioral of KeyFile is

    type keyfile_type is array(0 to 2**m-1) of std_logic_vector((n-1) downto 0);
    signal memory: keyfile_type;

begin

    process(memory, key_in)
    begin
        
        hit <= '0';
        for i in 0 to 2**m-1 loop
            if (memory(i) = key_in) then
                addr <= std_logic_vector(TO_UNSIGNED(i, addr'length));
                hit <= '1';
            end if;
        end loop;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                for i in 0 to 2**m-1 loop
                    memory(i) <= (others => '0');
                end loop;
            else
                for i in 0 to 2**m-1 loop
                    if (ld(i) = '1') then
                        memory(i) <= key_in;
                    end if;
                end loop;
            end if;
        end if;
    
    end process;

end Behavioral;

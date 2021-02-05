library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rom is
    port(
        oe: in std_logic;
        addr: in std_logic_vector((3-1) downto 0);
        data: out std_logic_vector((4-1) downto 0)
    );
end rom;

architecture Behavioral of rom is

    type rom_mem is array(0 to 2**3-1) of std_logic_vector((4-1) downto 0);
    signal memory: rom_mem := (
        "0000",
        "0000",
        "1100",
        "0001",
        "0000",
        "0000",
        "0010",
        "0000"
    );

begin

    process(oe, addr)
    begin
    
        if (oe = '1') then
            data <= memory(TO_INTEGER(unsigned(addr)));
        end if;
    
    end process;

end Behavioral;

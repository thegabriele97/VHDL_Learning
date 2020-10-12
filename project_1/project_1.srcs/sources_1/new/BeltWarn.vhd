library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BeltWarn is
    port(
        k, p, s: in std_logic;
        w_n: out std_logic;
        w: inout std_logic
    );
end BeltWarn;

architecture BeltWarn_arch of BeltWarn is

    component AND2 is
        port (
            X, Y: in std_logic;
            O:    out std_logic
        );
    end component;
    
    component Inv is
        port(
            x: in std_logic;
            y: out std_logic
        );
    end component;
    
    signal o1, o2: std_logic;

begin

    and_1: And2 port map(k, p, o1);
    not_1: Inv port map(s, o2);
    and_2: And2 port map(o1, o2, w);
    
    process(w)
    begin
    
        w_n <= not(w);
    
    end process;

end BeltWarn_arch;

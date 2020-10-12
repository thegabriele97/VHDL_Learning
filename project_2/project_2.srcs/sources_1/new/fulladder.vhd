library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
    port(
        a, b: in std_logic;
        sum, carry: out std_logic
    );
end fulladder;

architecture fulladder_arch of fulladder is
    
    component and2 is
        port(
            x, y: in std_logic;
            o: out std_logic
        );
    end component;
    
begin
    
    and2_gate: and2 port map(a, b, carry);
    
    process(a, b)
    begin
        sum <= a xor b;
        -- carry <= a and b;
    end process;
    
end fulladder_arch;
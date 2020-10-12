library ieee;
use ieee.std_logic_1164.all;

entity real_fulladder is
    port(
        a, b, c_in: in std_logic;
        s, c_out: out std_logic
    );
end real_fulladder;

architecture real_fulladder_arc of real_fulladder is
    
    component fulladder is
        port(
            a, b: in std_logic;
            sum, carry: out std_logic
        );
    end component;
    
    signal sum1_s, carry1_s, carry2_S: std_logic;
    
begin

    halfadder_1: fulladder port map(a, b, sum1_s, carry1_s);
    halfadder_2: fulladder port map(sum1_s, c_in, s, carry2_s);

    process(carry1_s, carry2_s)
    begin
        c_out <= carry1_s or carry2_s;
    end process;
    
end real_fulladder_arc;
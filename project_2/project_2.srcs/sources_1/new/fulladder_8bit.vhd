library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladder_8bit is
    port(
        d: in std_logic_vector(7 downto 0);
        c_in: in std_logic;
        s: out std_logic_vector(3 downto 0);
        c_out: out std_logic
    );
end fulladder_8bit;

architecture fulladder_8bit_arch of fulladder_8bit is

    component real_fulladder is
        port(
            a, b, c_in: in std_logic;
            s, c_out: out std_logic
        );
    end component;
    
    signal carry1, carry2, carry3, carry4: std_logic; 
    
begin

    fulladder_0: real_fulladder port map(d(0), d(1), c_in, s(0), carry1);
    fulladder_1: real_fulladder port map(d(2), d(3), carry1, s(1), carry2);
    fulladder_2: real_fulladder port map(d(4), d(5), carry2, s(2), carry3);
    fulladder_3: real_fulladder port map(d(6), d(7), carry3, s(3), c_out);
    
    -- fulladder_4: real_fulladder port map(sum4, d(4), carry4, s(4), carry5);
    -- fulladder_5: real_fulladder port map(sum5, d(5), carry5, s(5), carry6);
    -- fulladder_6: real_fulladder port map(sum6, d(6), carry6, s(6), carry7);
    -- fulladder_7: real_fulladder port map(sum7, d(7), carry7, s(7), c_out);

end fulladder_8bit_arch;
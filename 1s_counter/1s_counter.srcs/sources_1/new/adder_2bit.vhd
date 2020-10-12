library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_2bit is
    port(
        a: in std_logic_vector(1 downto 0);
        b: in std_logic_vector(1 downto 0);
        o: out std_logic_vector(1 downto 0);
        c_out: out std_logic
    );
end adder_2bit;

architecture adder_2bit_arch of adder_2bit is

    component half_adder is
        port(
            i: in std_logic_vector(1 downto 0);
            o, c: out std_logic
        );
    end component;
    
    component full_adder is
        port(
            c_in: in std_logic;
            i: in std_logic_vector(1 downto 0);
            o, c_out: out std_logic
        );
    end component;

    signal c: std_logic;

begin

    adder_1: half_adder port map(i(0) => a(0), i(1) => b(0), o => o(0), c => c);
    adder_2: full_adder port map(i(0) => a(1), i(1) => b(1), c_in => c, o => o(1), c_out => c_out);

end adder_2bit_arch;

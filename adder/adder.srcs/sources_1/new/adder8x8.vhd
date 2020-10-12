library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder8x8 is
    port(
        a, b: in std_logic_vector(7 downto 0);
        c_in: in std_logic;
        o: out std_logic_vector(7 downto 0);
        c_out: out std_logic
    );
end adder8x8;

architecture adder_arch of adder8x8 is

    component full_adder is
        port(
            full_a, full_b, c_in: in std_logic;
            full_s, full_c_out: out std_logic
        );
    end component;
    
    signal part_c: std_logic_vector(7 downto 0);

begin

    fa_0: full_adder port map(a(0), b(0), c_in, o(0), part_c(0));
    fa_1: full_adder port map(a(1), b(1), part_c(0), o(1), part_c(1));
    fa_2: full_adder port map(a(2), b(2), part_c(1), o(2), part_c(2));
    fa_3: full_adder port map(a(3), b(3), part_c(2), o(3), part_c(3));
    fa_4: full_adder port map(a(4), b(4), part_c(3), o(4), part_c(4));
    fa_5: full_adder port map(a(5), b(5), part_c(4), o(5), part_c(5));
    fa_6: full_adder port map(a(6), b(6), part_c(5), o(6), part_c(6));
    fa_7: full_adder port map(a(7), b(7), part_c(6), o(7), c_out);
    
end adder_arch;

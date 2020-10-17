library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hamming_dist is
    port(
        a, b: in std_logic_vector(7 downto 0);
        dist: out std_logic_vector(3 downto 0)
    );
end hamming_dist;

architecture Structural of hamming_dist is

    component adder_nbits is
        generic(
            nbits: integer := 4
        );
        port(
            a, b: in std_logic_vector((nbits-1) downto 0);
            sum: out std_logic_vector((nbits-1) downto 0);
            c_out: out std_logic
        );
    end component;
    
    signal diff, sum1: std_logic_vector(7 downto 0);
    signal sum2: std_logic_vector(6 downto 0);
    
begin

    diff <= a xor b;

    adder_1bit_gen: for i in 0 to 8 generate
        adders_gen: if (i >= 0 and i < 8 and (i mod 2) = 0) generate
            adder_1bit: adder_nbits generic map(nbits => 1) port map(
                a => diff(i downto i),
                b => diff((i+1) downto (i+1)),
                sum => sum1(i downto i),
                c_out => sum1(i+1)
            );
        end generate;
    end generate;

    adder_2bit_gen: for i in 0 to 4 generate
        adders_gen: if (i >= 0 and i <= 4 and (i mod 4) = 0) generate
            adder_2bit: adder_nbits generic map(nbits => 2) port map(
                a => sum1((i+1) downto i),
                b => sum1((i+3) downto (i+2)),
                sum => sum2((i+1) downto i),
                c_out => sum2(i+2)
            );
        end generate;
    end generate;
    
    adder_3bit: adder_nbits generic map(nbits => 3) port map(
        a => sum2(2 downto 0),
        b => sum2(6 downto 4),
        sum => dist(2 downto 0),
        c_out => dist(3)
    );

end Structural;

architecture Behav of hamming_dist is
begin

    process(a, b)
    
        variable diff: std_logic_vector(7 downto 0);
        variable cnt: unsigned(3 downto 0);
    
    begin
    
        diff := a xor b;
        cnt := ("000" & diff(0)) + ('0' & diff(1)) + ('0' & diff(2)) + ('0' & diff(3)) +
                 ('0' & diff(4)) + ('0' & diff(5)) + ('0' & diff(6)) + ('0' & diff(7));
                 
        dist <= std_logic_vector(cnt);
    
    end process;

end Behav;
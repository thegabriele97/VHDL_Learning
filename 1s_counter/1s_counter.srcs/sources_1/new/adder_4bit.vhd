library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_4bit is
    port(
        a: in std_logic_vector(3 downto 0);
        b: in std_logic_vector(3 downto 0);
        c_in: in std_logic;
        o: out std_logic_vector(3 downto 0);
        c_out: out std_logic
    );
end adder_4bit;

architecture adder_4bit_arch of adder_4bit is
    
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

    signal c: std_logic_vector(2 downto 0);

begin

    adder_1: full_adder port map(i(0) => a(0), i(1) => b(0), c_in => c_in, o => o(0), c_out => c(0));
    adder_2: full_adder port map(i(0) => a(1), i(1) => b(1), c_in => c(0), o => o(1), c_out => c(1));
    adder_3: full_adder port map(i(0) => a(2), i(1) => b(2), c_in => c(1), o => o(2), c_out => c(2));
    adder_4: full_adder port map(i(0) => a(3), i(1) => b(3), c_in => c(2), o => o(3), c_out => c_out);
    

end adder_4bit_arch;

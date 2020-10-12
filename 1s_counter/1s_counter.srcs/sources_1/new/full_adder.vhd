library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    port(
        c_in: in std_logic;
        i: in std_logic_vector(1 downto 0);
        o, c_out: out std_logic
    );
end full_adder;

architecture Behavioral of full_adder is
    
    component half_adder is
        port(
            i: in std_logic_vector(1 downto 0);
            o, c: out std_logic
        );
    end component;
    
    signal sum1, carry1: std_logic;
    signal sum2, carry2: std_logic;
    
begin

    half_adder_1: half_adder port map(i, sum1, carry1);
    half_adder_2: half_adder port map(
        i(0) => sum1,
        i(1) => c_in, 
        o => o, 
        c => carry2
    );
    
    c_out <= carry1 or carry2;

end Behavioral;

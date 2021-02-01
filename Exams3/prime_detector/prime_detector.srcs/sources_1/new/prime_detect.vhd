library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity prime_detect is
    port(
        n: in std_logic_vector(3 downto 0);
        z: out std_logic
    );
end prime_detect;

architecture struct of prime_detect is

    component or_gate is
        port(
            x: in std_logic_vector(3 downto 0);
            y: out std_logic
        );
    end component;

    component and_gate is
        port(
            x: in std_logic_vector(2 downto 0);
            y: out std_logic
        );
    end component;

    signal n_n: std_logic_vector(3 downto 0);
    signal wow: std_logic_vector(3 downto 0);

begin

    n_n <= not n;
    
    A1: and_gate port map(x(2) => '1', x(1) => n_n(3), x(0) => n(0), y => wow(3));
    A2: and_gate port map(x(2) => n(2), x(1) => n_n(1), x(0) => n(0), y => wow(2));
    A3: and_gate port map(x(2) => n_n(2), x(1) => n(1), x(0) => n(0), y => wow(1));
    A0: and_gate port map(x(2) => n_n(3), x(1) => n_n(2), x(0) => n(1), y => wow(0));

    O0: or_gate port map(x => wow, y => z);

end struct;

library ieee;
use ieee.std_logic_1164.all;

entity prime_detector is
    port(
        n: in std_logic_vector(3 downto 0);
        z: out std_logic
    );
end prime_detector;

architecture struct of prime_detector is
    
    component or_gate is
        generic(
            n_in: integer
        );
        port(
            a: in std_logic_vector((n_in-1) downto 0);
            y: out std_logic
        );
    end component ;

    component and_gate is
        generic(
            n_in: integer
        );
        port(
            a: in std_logic_vector((n_in-1) downto 0);
            y: out std_logic
        );
    end component;
    
    signal n_n, a: std_logic_vector(3 downto 0);
    
begin
    
    n_n <= not n;
    
    AND0: and_gate generic map(n_in => 2)
        port map(
            a(1) => n_n(3),
            a(0) => n(0),
            y => a(3)
        );
    
    AND1: and_gate generic map(n_in => 3)
        port map(
            a(2) => n(2),
            a(1) => n_n(1),
            a(0) => n(0),
            y => a(2)
        );    
        
    AND2: and_gate generic map(n_in => 3)
        port map(
            a(2) => n_n(2),
            a(1) => n(1),
            a(0) => n(0),
            y => a(1)
        );           
        
    AND3: and_gate generic map(n_in => 3)
        port map(
            a(2) => n_n(3),
            a(1) => n_n(2),
            a(0) => n(1),
            y => a(0)
        );          
        
    OR0: or_gate generic map(n_in => 4)
        port map(
            a => a,
            y => z
        ); 
    
end struct;
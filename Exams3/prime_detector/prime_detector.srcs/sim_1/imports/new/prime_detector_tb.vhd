library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity prime_detector_tb is
end prime_detector_tb;

architecture Behavioral of prime_detector_tb is

    component prime_detect is
        port(
            n: in std_logic_vector(3 downto 0);
            z: out std_logic
        );
    end component;

    signal n: std_logic_vector(3 downto 0);
    signal z: std_logic;

begin

    DUT: prime_detect port map(n, z);

    process
    begin
    
        n <= std_logic_vector(TO_UNSIGNED(1, n'length));
        wait for 1 ns;
        
        n <= std_logic_vector(TO_UNSIGNED(4, n'length));
        wait for 1 ns;
        
        n <= std_logic_vector(TO_UNSIGNED(5, n'length));
        wait for 1 ns;
        
        n <= std_logic_vector(TO_UNSIGNED(11, n'length));
        wait for 1 ns;
        
        n <= std_logic_vector(TO_UNSIGNED(14, n'length));
        wait for 1 ns;
        
        n <= std_logic_vector(TO_UNSIGNED(7, n'length));
        wait;
        
    end process;


end Behavioral;

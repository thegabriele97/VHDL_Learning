library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tm2b_tb is
end tm2b_tb;

architecture Behavioral of tm2b_tb is

    component tb2b is
        port(
            x: in std_logic_vector(6 downto 0);
            z: out std_logic_vector(2 downto 0)
        );
    end component;
    
    signal x: std_logic_vector(6 downto 0);
    signal z: std_logic_vector(2 downto 0);

begin

    DUT: tb2b port map(x, z);

    process
    begin
    
        x <= "0011111";
        wait for 1 ns;
    
        x <= "0000011";
        wait for 1 ns;
        
        x <= "0000001";
        wait for 1 ns;
        
        x <= "0000000";
        wait for 1 ns;
        
        wait;
    
    end process;

end Behavioral;

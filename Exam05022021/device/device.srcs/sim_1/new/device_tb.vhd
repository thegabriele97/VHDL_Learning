library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity device_tb is
end device_tb;

architecture Behavioral of device_tb is

    component device is
        port(
            m: in std_logic_vector(2 downto 0);
            A: out std_logic
        );
    end component;

    for DUT: device use entity work.device(case_when);

    signal m: std_logic_vector(2 downto 0);
    signal A: std_logic;

begin

    DUT: device port map(m, A);

    process
    begin
    
        m <= "101";
        wait for 1 ns;
        
        m <= "111";
        wait for 1 ns;
         
        m <= "001";
        wait for 1 ns;

        m <= "110";
        wait for 1 ns;        
        
        m <= "010";
        wait;
    
    end process;

end Behavioral;

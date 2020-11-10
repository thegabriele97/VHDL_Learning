library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_tb is
end fsm_tb;

architecture Behavioral of fsm_tb is

    component fsm is
        port(
            clk, rst, btn, laser_reflect: in std_logic;
            laser_on: out std_logic;
            measure: out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal clk, rst, btn, laser_reflect, laser_on: std_logic := '0';
    signal measure: std_logic_vector(15 downto 0);

begin

    DUT: fsm port map(clk, rst, btn, laser_reflect, laser_on, measure);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        btn <= '1';
        wait for 1 ns;
        
        btn <= '0';
        wait for 100 ns;
        
        laser_reflect <= '1';
        wait for 1 ns;
        
        laser_reflect <= '0';
        
        wait;
    
    end process;

end Behavioral;

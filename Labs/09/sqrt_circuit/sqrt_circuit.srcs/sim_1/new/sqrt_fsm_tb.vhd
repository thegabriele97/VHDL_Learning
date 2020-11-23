library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sqrt_fsm_tb is
end sqrt_fsm_tb;

architecture Behavioral of sqrt_fsm_tb is

    component sqrt_fsm is
        port(
            clk, rst, start: in std_logic;
            a, b: in std_logic_vector(7 downto 0);
            ready: out std_logic;
            res: out std_logic_vector(8 downto 0)
        );
    end component;

    for DUT: sqrt_fsm use entity work.sqrt_fsm(fsmd);

    signal clk, rst, start, ready: std_logic := '0';
    signal a, b: std_logic_vector(7 downto 0);
    signal res: std_logic_vector(8 downto 0);

begin

    DUT: sqrt_fsm port map(clk, rst, start, a, b, ready, res);

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
        wait for 0 ns;
        
        a <= x"78";
        b <= x"ce";
        start <= '1';
        wait for 1 ns;
        
        start <= '0';
        wait for 4 ns;
        
        wait;
    
    end process;

end Behavioral;

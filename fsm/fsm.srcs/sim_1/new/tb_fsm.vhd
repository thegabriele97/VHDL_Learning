library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm is
end tb_fsm;

architecture Behavioral of tb_fsm is

    component fsm is
        port(
            clk, rst: in std_logic;
            reg: out std_logic_vector(1 downto 0)
        );
    end component;

    signal clk, rst: std_logic := '0';
    signal reg: std_logic_vector(1 downto 0);

begin

    DUT: fsm port map(clk, rst, reg);
    
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
        wait;
    
    end process;


end Behavioral;

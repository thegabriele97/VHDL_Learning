library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm is
--  Port ( );
end tb_fsm;

architecture Behavioral of tb_fsm is

    component fsm is
        port(
            m, clk, rst: std_logic;
            cnt: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal m, clk, rst: std_logic := '0';
    signal cnt: std_logic_vector(3 downto 0);

begin

    DUT: fsm port map(m, clk, rst, cnt);
    
    process
    begin
        
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;
    
    process
    begin
    
        rst <= '1';
        wait for 2 ns;
        
        rst <= '0';
        wait for 0 ns;
        
        for i in 0 to 10 loop
            m <= not m;
            wait for 1 ns;
        end loop;
        
        for i in 0 to 6 loop
            m <= not m;
            wait for 2.5 ns;
        end loop;
        
        m <= '0';
        wait;
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity counter_tb is
--  Port ( );
end counter_tb;

architecture Behavioral of counter_tb is

    component counter is
        port(
            clk, rst, m: in std_logic;
            cnt: out std_logic_vector(31 downto 0)
        );
    end component;

    signal clk, rst, m: std_logic := '0';
    signal cnt: std_logic_vector(31 downto 0);

begin

    DUT: counter port map(clk, rst, m, cnt);

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
        
        
        for i in 0 to 7 loop
            m <= TO_UNSIGNED(i, 3)(0);
            wait for 1 ns;
        end loop;
        
        m <= '1';
        wait for 3 ns;
        
        m <= '0';
        wait for 2 ns;
        
        m <= '1';
        wait for 9 ns;
        
        m <= '0';
        wait;
        
    
    end process;

end Behavioral;

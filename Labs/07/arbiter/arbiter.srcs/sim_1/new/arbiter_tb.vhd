library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity arbiter_tb is
end arbiter_tb;

architecture Behavioral of arbiter_tb is

    component arbiter is
        port(
            clk, rst: in std_logic;
            req: in std_logic_vector(1 downto 0);
            grant: out std_logic_vector(1 downto 0)
        );
    end component;
    
    for DUT: arbiter use entity work.arbiter(Moore_DynamicPriority);

    signal clk, rst: std_logic := '0';
    signal req, grant: std_logic_vector(1 downto 0);

begin

    DUT: arbiter port map(clk, rst, req, grant);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    begin
    
        rst <= '1';
        req <= "00";
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
    
        req(0) <= '1';
        wait for 2 ns;
        
        req(1) <= '1';
        wait for 1 ns;
        
        req(0) <= '0';
        wait for 1 ns;
        
        req(0) <= '1';
        wait for 3 ns;
        
        req(1) <= '0';
        wait for 1 ns;
        
        req(0) <= '0';
        wait for 1 ns;
        
        wait;
    
    end process;


end Behavioral;

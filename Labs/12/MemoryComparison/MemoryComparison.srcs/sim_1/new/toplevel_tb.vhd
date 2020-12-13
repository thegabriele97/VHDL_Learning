library ieee;
use ieee.std_logic_1164.all;

entity toplevel_tb is
end entity;

architecture behav of toplevel_tb is

    component toplevel is
        port(
            clk, rst, go: in std_logic;
            DataIn: in std_logic_vector(3 downto 0);
            finish: out std_logic;
            cnt: out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk, rst, go, finish: std_logic := '0';
    signal di, cnt: std_logic_vector(3 downto 0);

begin

    DUT: toplevel port map(clk, rst, go, di, finish, cnt);

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
        
        di <= x"f";
        go <= '1';
        wait until finish = '1';
        
        go <= '0';
        wait;
    
    end process;

end behav;
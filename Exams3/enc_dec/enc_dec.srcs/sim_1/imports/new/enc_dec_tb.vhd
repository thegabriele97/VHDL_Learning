library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enc_dec_tb is
end enc_dec_tb;

architecture Behavioral of enc_dec_tb is

    component device is
        port(
            clk, rst, b, e, d: in std_logic;
            i: in std_logic_vector(15 downto 0);
            o: out std_logic_vector(15 downto 0)
        );
    end component;
    
    for DUT: device use entity work.device(fsmd);
    
    signal clk, rst, b, e, d: std_logic := '0';
    signal i, o: std_logic_vector(15 downto 0);

begin

    DUT: device port map(clk, rst, b, e, d, i, o);

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
        
        b <= '1';
        i <= x"aaaa";
        wait for 2 ns;
        
        b <= '0';
        e <= '1';
        i <= x"f00a";
        wait for 2 ns;
        
        e <= '0';
        d <= '1';
        i <= o;
        wait for 2 ns;
        
        d <= '0';
        wait;
    
    end process;
    
    
end Behavioral;

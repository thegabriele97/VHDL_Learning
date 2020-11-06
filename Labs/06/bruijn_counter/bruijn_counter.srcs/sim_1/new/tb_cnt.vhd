library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cnt is
--  Port ( );
end tb_cnt;

architecture Behavioral of tb_cnt is

    component counter is
        port(
            clk, ld: in std_logic;
            ld_seed: in std_logic_vector(7 downto 0);
            reg: out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk, ld: std_logic := '0';
    signal ld_seed, rg: std_logic_vector(7 downto 0);
    
begin

    DUT: counter port map(clk, ld, ld_seed, rg);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;
    
    process
    begin
    
        ld_seed <= x"aa";
        ld <= '1';
        
        wait for 1 ns;
        
        ld <= '0';
        wait for 10 ns;
        
        ld_seed <= x"00";
        ld <= '1';
        
        wait for 1 ns;
        
        ld <= '0';
        wait for 10 ns;
        
        wait;
    
    end process;

end Behavioral;

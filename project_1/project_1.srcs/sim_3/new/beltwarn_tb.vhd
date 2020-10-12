library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity beltwarn_tb is
end beltwarn_tb;

architecture beltwarn_tb_arch of beltwarn_tb is

    component BeltWarn is
        port(
            k, p, s: in std_logic;
            w_n: out std_logic;
            w: inout std_logic
        );
    end component;

    signal k_s, p_s, s_s, w_n_s, w_s: std_logic;

begin

    bw_test: BeltWarn port map(k_s, p_s, s_s, w_n_s, w_s);
    
    process
    begin
        k_s <= '0';
        p_s <= '1';
        s_s <= '0';
        
        wait for 10 ns;
        
        k_s <= '1';
        p_s <= '1';
        s_s <= '0';
        
        wait for 10ns;
    end process;

end beltwarn_tb_arch;

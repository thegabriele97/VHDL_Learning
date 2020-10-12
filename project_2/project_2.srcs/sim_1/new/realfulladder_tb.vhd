library ieee;
use ieee.std_logic_1164.all;

entity realfulladder_tb is
end realfulladder_tb;

architecture realfulladder_tb_arch of realfulladder_tb is
    
    component real_fulladder is
        port(
            a, b, c_in: in std_logic;
            s, c_out: out std_logic
        );
    end component;

    signal a_s, b_s, c_in_s, s_s, c_out_s: std_logic;
begin

    real_fa: real_fulladder port map(a_s, b_s, c_in_s, s_s, c_out_s);

    process
    begin
        c_in_s <= '1';
    
        a_s <= '0';
        b_s <= '0';
        wait for 10 ns;
        
        a_s <= '0';
        b_s <= '1';
        wait for 10 ns;
        
        a_s <= '1';
        b_s <= '0';
        wait for 10 ns;
        
        a_s <= '1';
        b_s <= '1';
        wait for 10ns;
    end process;

end realfulladder_tb_arch;

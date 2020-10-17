library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture Behavioral of tb is

    component delay_gate is
        port(
            d: in std_logic;
            trans_delay_o, inertial_delay_o, inertial_transport_o: out std_logic
        );
    end component;

    signal d_s, t_s, i_s, it_s: std_logic;

begin

    test: delay_gate port map(d_s, t_s, i_s, it_s);

    process
    begin
    
    d_s <= '0';
    wait for 1 ns;
    
    d_s <= '1';
    wait for 1 ns;
    
    d_s <= '0';
    wait for 1 ns;
    
    d_s <= '1';
    wait for 2 ns;
    
    d_s <= '0';
    wait for 1 ns;
    
    d_s <= '1';
    wait for 3 ns;
    
    d_s <= '0';
    wait for 1 ns;
    
    d_s <= '1';
    wait for 4 ns;
    
    d_s <= '0';
    wait for 1 ns;
    
    d_s <= '1';
    wait for 5 ns;
    
    d_s <= '0';
    wait for 1 ns;
    
    end process;

end Behavioral;

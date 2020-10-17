library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity delay_gate is
    port(
        d: in std_logic;
        trans_delay_o, inertial_delay_o, inertial_transport_o: out std_logic
    );
end delay_gate;

architecture Behavioral of delay_gate is
begin

    trans_delay_o <= transport d after 10 ns;
    inertial_delay_o <= d after 10ns;
    inertial_transport_o <= reject 4 ns inertial d after 10 ns;

end Behavioral;

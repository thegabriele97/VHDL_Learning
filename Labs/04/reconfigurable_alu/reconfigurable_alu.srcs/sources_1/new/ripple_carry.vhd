library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_carry is
    port(
        c_in_curr, c_out_curr2next, enable_curr: in std_logic;
        c_out_curr, c_out_next: out std_logic
    );
end ripple_carry;

architecture Behavioral of ripple_carry is
begin

    c_out_curr <= enable_curr and c_in_curr;
    c_out_next <= (not(enable_curr) and c_in_curr) or c_out_curr2next;

end Behavioral;

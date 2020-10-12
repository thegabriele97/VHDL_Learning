library ieee;
use ieee.std_logic_1164.all;

entity hamming_difference_mask is
    port(
        data_a, data_b: in std_logic_vector(7 downto 0);
        mask: out std_logic_vector(7 downto 0)
    );
end hamming_difference_mask;

architecture DataFlow of hamming_difference_mask is
begin

    mask <= data_a xor data_b;

end DataFlow;
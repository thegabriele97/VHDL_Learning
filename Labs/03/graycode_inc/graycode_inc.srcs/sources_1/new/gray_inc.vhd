library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity gray_inc is
    generic(
        n: integer := 4
    );
    port(
        gray_code: in std_logic_vector((n-1) downto 0);
        next_code: out std_logic_vector((n-1) downto 0)
    );
end gray_inc;

architecture Behavioral of gray_inc is

    signal curr_bit_code: std_logic_vector((n-1) downto 0);
    signal next_bit_code: unsigned((n-1) downto 0);

begin

    gray2bit_gen: for i in 0 to n-1 generate --computing current bit code from gray code
                                             -- * I was planning to make a for from n-1 to 0 but
        upper_bit: if i = 0 generate         -- * it doesn't work. Dont' ask me why, I hate everything
            curr_bit_code(n-1) <= gray_code(n-1);
        end generate;  
        
        other_bits: if i > 0 and i <= (n-1) generate
            curr_bit_code(n-1-i) <= curr_bit_code(n-i) xor gray_code(n-1-i);
        end generate;
    
    end generate gray2bit_gen;
    
    next_bit_code <= unsigned(curr_bit_code) + 1; --computing next bit code
    
    bit2gray_gen: for i in 0 to n-1 generate --computing current gray code from the new bit code
    
        upper_bit: if i = n-1 generate
            next_code(i) <= next_bit_code(i);
        end generate;
    
        other_bits: if i >= 0 and i < n-1 generate
            next_code(i) <= next_bit_code(i) xor next_bit_code(i+1);
        end generate; 
    
    end generate bit2gray_gen;

end Behavioral;

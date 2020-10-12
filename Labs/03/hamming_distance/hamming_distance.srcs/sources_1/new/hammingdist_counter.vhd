library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity hammingdist_counter is
    port(
        data_a, data_b: in std_logic_vector(7 downto 0);
        dist: out std_logic_vector(3 downto 0)
    );
end hammingdist_counter;

architecture Arch of hammingdist_counter is

    component hamming_difference_mask is
        port(
            data_a, data_b: in std_logic_vector(7 downto 0);
            mask: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component adder_1bit is
        port(
            a, b: in std_logic;
            sum, c_out: out std_logic
        );
    end component;
    
    component adder_2bit is
        port(
            a, b: in std_logic_vector(1 downto 0);
            sum: out std_logic_vector(1 downto 0);
            c_out: out std_logic
        );
    end component;
    
    component adder_3bit is
        port(
            a, b: in std_logic_vector(2 downto 0);
            sum: out std_logic_vector(2 downto 0);
            c_out: out std_logic
        );
    end component;
    
    signal mask_s, sum_1: std_logic_vector(7 downto 0);
    signal sum_2: std_logic_vector(5 downto 0);

begin

    hamming_mask_1: hamming_difference_mask port map(
        data_a => data_a, 
        data_b => data_b, 
        mask => mask_s
    );
    
    adder_1bit_1: adder_1bit port map(
        a => mask_s(0),
        b => mask_s(1),
        sum => sum_1(0),
        c_out => sum_1(1)
    );
    
     adder_1bit_2: adder_1bit port map(
        a => mask_s(2),
        b => mask_s(3),
        sum => sum_1(2),
        c_out => sum_1(3)
    );
    
     adder_1bit_3: adder_1bit port map(
        a => mask_s(4),
        b => mask_s(5),
        sum => sum_1(4),
        c_out => sum_1(5)
    );
    
     adder_1bit_4: adder_1bit port map(
        a => mask_s(6),
        b => mask_s(7),
        sum => sum_1(6),
        c_out => sum_1(7)
    );
    
    adder_2bit_1: adder_2bit port map(
        a => sum_1(1 downto 0),
        b => sum_1(3 downto 2),
        sum => sum_2(1 downto 0),
        c_out => sum_2(2)
    );
    
    adder_2bit_2: adder_2bit port map(
        a => sum_1(5 downto 4),
        b => sum_1(7 downto 6),
        sum => sum_2(4 downto 3),
        c_out => sum_2(5)
    );
    
    adder_3bit_1: adder_3bit port map(
        a => sum_2(2 downto 0),
        b => sum_2(5 downto 3),
        sum => dist(2 downto 0),
        c_out => dist(3)
    );
    
end Arch;

architecture Behavioral of hammingdist_counter is
begin

    process(data_a, data_b)
    
        variable ones_mask: std_logic_vector(7 downto 0);
        variable ones_sum: unsigned(3 downto 0);
        
    begin
    
        ones_mask := data_a xor data_b;
        ones_sum := ("000" & ones_mask(0)) + ("000" & ones_mask(1)) + 
                    ("000" & ones_mask(2)) + ("000" & ones_mask(3)) + 
                    ("000" & ones_mask(4)) + ("000" & ones_mask(5)) + 
                    ("000" & ones_mask(6)) + ("000" & ones_mask(7));
                    
        dist <= std_logic_vector(ones_sum);
    
    end process;

end Behavioral;

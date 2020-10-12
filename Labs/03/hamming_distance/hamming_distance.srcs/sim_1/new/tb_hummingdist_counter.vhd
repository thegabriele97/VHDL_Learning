library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_hummingdist_counter is
end tb_hummingdist_counter;

architecture Behavioral of tb_hummingdist_counter is

    component hammingdist_counter is
        port(
            data_a, data_b: in std_logic_vector(7 downto 0);
            dist: out std_logic_vector(3 downto 0)
        );
    end component;

    for test: hammingdist_counter use entity work.hammingdist_counter(Arch);

    signal data_a_s, data_b_s: std_logic_vector(7 downto 0);
    signal dist_s: std_logic_vector(3 downto 0);

begin

    test: hammingdist_counter port map(data_a => data_a_s, data_b => data_b_s, dist => dist_s);

    process
    begin
    
        data_a_s <= "00000000";
        data_b_s <= "00000000";
        wait for 10 ns;
    
        data_a_s <= "11111111";
        data_b_s <= "11111111";
        wait for 10 ns;
        
        data_a_s <= "00000000";
        data_b_s <= "11111111";
        wait for 10 ns;
        
        data_a_s <= "11111111";
        data_b_s <= "00000000";
        wait for 10 ns;
        
        data_a_s <= "00010011";
        data_b_s <= "10010010";
        wait for 10 ns;
        
        data_b_s <= "11011101";
        wait for 10 ns;
    
    end process;

end Behavioral;

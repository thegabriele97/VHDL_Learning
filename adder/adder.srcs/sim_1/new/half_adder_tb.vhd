library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder_tb is
end half_adder_tb;

architecture half_adder_tb_arch of half_adder_tb is
    
    component half_adder is
        port(
            i: in std_logic_vector(1 downto 0);
            o, c_out: out std_logic
        );
    end component;
    
    signal i_s: std_logic_vector(1 downto 0);
    signal s_s, c_out_s: std_logic;
    
begin

    half_adder_test: half_adder port map(i_s, s_s, c_out_s);

    process
    begin
    
        i_s <= "00";
        wait for 10 ns;
        
        i_s <= "01";
        wait for 10 ns;
        
        i_s <= "10";
        wait for 10 ns;
        
        i_s <= "11";
        wait for 10 ns;
    
    end process;

end half_adder_tb_arch;

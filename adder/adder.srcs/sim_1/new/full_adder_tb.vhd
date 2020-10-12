library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_tb is
end full_adder_tb;

architecture full_adder_tb_arch of full_adder_tb is

    component full_adder is
        port(
            c_in: in std_logic;
            i: in std_logic_vector(1 downto 0);
            o, c_out: out std_logic
        );
    end component;

    signal c_in_s: std_logic := '0';
    signal a_s, b_s, s_s, c_out_s: std_logic;
    
begin

    full_adder_test: full_adder port map(
        i(0) => a_s,
        i(1) => b_s, 
        c_in => c_in_s,
        o => s_s, 
        c_out => c_out_s
    );
    
    process
    begin
   
        c_in_s <= not(c_in_s);

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
        wait for 10 ns;
    
    end process;

end full_adder_tb_arch;

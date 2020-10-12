library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder4_tb is
end adder4_tb;

architecture adder4_tb_arch of adder4_tb is

    component adder_4bit is
        port(
            a: in std_logic_vector(3 downto 0);
            b: in std_logic_vector(3 downto 0);
            o: out std_logic_vector(3 downto 0);
            c_out: out std_logic
        );
    end component;

    signal a_s, b_s, o_s: std_logic_vector(3 downto 0);
    signal c_out: std_logic;

begin

    adder_test: adder_4bit port map(a_s, b_s, o_s, c_out);

    process
    begin
    
        a_s <= "0101";
        b_s <= "1010";
        wait;
        
    end process;

end adder4_tb_arch;

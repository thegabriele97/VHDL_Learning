library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_adder_8bit is
end tb_adder_8bit;

architecture Behavioral of tb_adder_8bit is

    component adder_8bit is
        port(
            a, b: in std_logic_vector(7 downto 0);
            sum: out std_logic_vector(7 downto 0);
            c_out: out std_logic
        );
    end component;

    signal a_s, b_s, sum_s: std_logic_vector(7 downto 0);
    signal c_out_s: std_logic;
    
begin

    test: adder_8bit port map(a_s, b_s, sum_s, c_out_s);
    
    process
    begin
    
        a_s <= "00000010";
        b_s <= "00000011";
        wait;
    
    end process;

end Behavioral;

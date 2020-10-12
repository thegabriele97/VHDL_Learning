library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity converter_tb is
end converter_tb;

architecture Behavioral of converter_tb is

    component converter is
        port(
            i: in std_logic_vector(7 downto 0);
            o: out std_logic_vector(3 downto 0);
            c_out: out std_logic
        );
    end component;

    signal i_s: std_logic_vector(7 downto 0);
    signal o_s: std_logic_vector(3 downto 0);
    signal c_out_s: std_logic;

begin

    converter_test: converter port map(i_s, o_s, c_out_s);    

    process
    begin
    
        i_s(3 downto 0) <= "0001";
        i_s(7 downto 4) <= "0010";
        wait;
    
    end process;

end Behavioral;

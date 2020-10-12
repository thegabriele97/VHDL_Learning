library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder4bit_tb is
end adder4bit_tb;

architecture Behavioral of adder4bit_tb is

    component adder4bit is
        port(
            a, b: in std_logic_vector(3 downto 0);
            c_in: in std_logic;
            s: out std_logic_vector(3 downto 0);
            c_out: out std_logic
        );
    end component;
    
    signal a_s, b_s, s_s: std_logic_vector(3 downto 0);
    signal c_in_s, c_out_s: std_logic;

begin

    adder4bit_test: adder4bit port map(a_s, b_s, c_in_s, s_s, c_out_s);

    process
    begin
    
        a_s <= "1000";
        b_S <= "0111";
        c_in_s <= '1';
        
        wait;
    
    end process;
    
end Behavioral;

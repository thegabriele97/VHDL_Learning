library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_4bit is
    port(
        a, b: in std_logic_vector(3 downto 0);
        c_in: in std_logic;
        o: out std_logic_vector(3 downto 0);
        c_out: out std_logic
    );
end adder_4bit;

architecture Behavioral of adder_4bit is

    component full_adder is
        port(
            i: in std_logic_vector(1 downto 0);
            c_in: in std_logic;
            o, c_out, ripple: out std_logic
        );
    end component;

    signal ripple: std_logic_vector(3 downto 0);
begin

    process(ripple)
    begin
    
        if ripple(0) = '1' then
            
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_config_alu is
end tb_config_alu;

architecture Behavioral of tb_config_alu is

    component reconfigurable_alu is
        port(
            a, b: in std_logic_vector(15 downto 0);
            nibble: in std_logic_vector(3 downto 0);
            ctrl: in std_logic_vector(2 downto 0);
            result: out std_logic_vector(15 downto 0)
        );
    end component;

    signal a, b, result: std_logic_vector((16-1) downto 0);
    signal nibble: std_logic_vector(3 downto 0);
    signal ctrl: std_logic_vector(2 downto 0);

begin

    test: reconfigurable_alu port map(a, b, nibble, ctrl, result);

    process
    begin
    
        a <= x"abcd";
        b <= x"aaaa";
        nibble <= "1010";
        ctrl <= "001";
        wait for 10 ns;
        
        ctrl <= "100";
        wait for 10 ns;
        
        nibble <= "0101";
        wait for 10 ns;
        
        nibble <= "1100";
        wait for 10 ns;
        
        nibble <= "1111";
        wait for 10 ns;
        
        a <= x"9999";
        wait for 10 ns;
        
        ctrl <= "110";
        wait for 10 ns;
    
    end process;

end Behavioral;

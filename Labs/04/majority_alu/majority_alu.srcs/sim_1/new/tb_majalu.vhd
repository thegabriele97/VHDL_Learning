library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_majalu is
end tb_majalu;

architecture Behavioral of tb_majalu is

    component majority_alu is
        generic(
            nbits: integer := 8
        );
        port(
            a, b, c, d, e, f: in std_logic_vector((nbits - 1) downto 0);
            ctrl: in std_logic_vector(2 downto 0);
            decision: out std_logic_vector((nbits - 1) downto 0);
            data_valid: out std_logic
        );
    end component;

    signal a, b, c, d, e, f, dec: std_logic_vector(7 downto 0);
    signal ctrl: std_logic_vector(2 downto 0);
    signal data_valid: std_logic;
    
begin

    test: majority_alu generic map(8) port map(a, b, c, d, e, f, ctrl, dec, data_valid);
    
    process
    begin
        
        ctrl <= "000";
        
        a <= x"fe";
        b <= x"ff";
        
        c <= x"fe";
        d <= x"ff";
        
        e <= x"fe";
        f <= x"ff";
        wait for 10 ns;
        
        a <= x"fe";
        b <= x"ff";
        
        c <= x"ff";
        d <= x"fe";
        
        e <= x"fe";
        f <= x"ff";
        wait for 10 ns;
        
        a <= x"ff";
        b <= x"fe";
        
        c <= x"fe";
        d <= x"fe";
        
        e <= x"fe";
        f <= x"ff";
        wait for 10 ns;
        
        a <= x"ff";
        b <= x"ff";
        
        c <= x"fd";
        d <= x"fe";
        
        e <= x"fe";
        f <= x"ff";
        wait for 10 ns;
        
        e <= x"00";
        wait for 10 ns;
        
        a <= x"fe";
        wait for 10 ns;
        
        ctrl <= "101";
        wait for 10 ns;
        
        ctrl <= "110";
        wait for 10 ns;
    
    end process;

end Behavioral;

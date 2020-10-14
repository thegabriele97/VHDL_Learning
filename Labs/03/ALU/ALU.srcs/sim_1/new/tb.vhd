library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture Behavioral of tb is

    component ALU is
        generic(
            nbit: integer := 8
        );
        port(
            src1, src2: in std_logic_vector((nbit-1) downto 0);
            ctrl: in std_logic_vector(2 downto 0);
            result: out std_logic_vector((nbit-1) downto 0)
        );
    end component;

    signal src1_s, src2_s, res_s: std_logic_vector(7 downto 0);
    signal ctrl_s: std_logic_vector(2 downto 0);
    
begin

    test: ALU generic map(8) port map(src1_s, src2_s, ctrl_s, res_s);

    process
    begin
    
        ctrl_s <= "010";
        src1_s <= "11111011";
        wait for 1 ns;
        assert res_s = "11111111" report "bad increment, should be =11111111" severity error;
        wait for 9 ns;
        
        ctrl_s <= "100";
        src1_s <= "00000011";
        src2_s <= "10000100";
        wait for 1 ns;
        assert res_s = "10000111" report "bad increment, should be =10000111" severity error;
        wait for 9 ns;
        
    
    end process;

end Behavioral;

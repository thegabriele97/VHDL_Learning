library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_enh_alu is
end tb_enh_alu;

architecture Behavioral of tb_enh_alu is

    component FullALU is
        generic(
            nbits: integer := 8
        );
        port(
            src1, src2: in std_logic_vector((nbits-1) downto 0);
            ctrl: in std_logic_vector(2 downto 0);
            c_in, enable: in std_logic;
            result: out std_logic_vector((nbits-1) downto 0);
            c_out: out std_logic
        );
    end component;
    
    signal src1, src2, result: std_logic_vector(3 downto 0);
    signal ctrl: std_logic_vector(2 downto 0);
    signal c_in, c_out, enable: std_logic;

begin

    test: FullALU generic map(nbits => 4) port map(src1, src2, ctrl, c_in, enable, result, c_out);
    
    process
    begin
    
        ctrl <= "100";
        enable <= '0';
        c_in <= '1';
        src1 <= x"1";
        src2 <= x"3";
        wait for 10 ns;
        
        enable <= '1';
        wait for 10 ns;
        
        src2 <= x"a";
        wait for 10 ns;
        
        ctrl <= "101";
        wait for 10 ns;
        
        ctrl <= "001";
        wait for 10 ns;
        
        ctrl <= "110";
        wait for 10 ns;
        
    end process;

end Behavioral;

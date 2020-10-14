library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_barrel is
end tb_barrel;

architecture Behavioral of tb_barrel is

    component barrel_shifter is
        port(
            d_in: in std_logic_vector(7 downto 0);
            lar: in std_logic_vector(1 downto 0);
            amt: in std_logic_vector(2 downto 0);
            d_out: out std_logic_vector(7 downto 0)
        );
    end component;

    signal d_in_s, d_out_s: std_logic_vector(7 downto 0);
    signal amt_s: std_logic_vector(2 downto 0);
    signal lar_s: std_logic_vector(1 downto 0) := "00";

begin

    barrel_test: barrel_shifter port map(d_in_s, lar_s, amt_s, d_out_s);
    
    process
        variable tb_lar: std_logic_vector(1 downto 0);
    begin
        
        d_in_s <= "11100100";
        amt_s <= "000";
        wait for 10 ns;
    
        amt_s <= "001";
        wait for 10 ns;
        
        amt_s <= "100";
        wait for 10 ns;
        
        amt_s <= "111";
        wait for 10 ns;
        
        if (lar_s /= "10") then
            tb_lar(1) := lar_s(0);
            tb_lar(0) := lar_s(0) xor '1';
            lar_s <= tb_lar;
        else
            lar_s <= "00";
        end if;
        
    end process;

end Behavioral;

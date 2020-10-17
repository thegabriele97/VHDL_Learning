library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm is
end tb_fsm;

architecture Behavioral of tb_fsm is

    component btn_fsm2 is
        port(
            btn: in std_logic_vector(1 downto 0);
            clk: in std_logic;
            leds: out std_logic_vector(1 downto 0)
        );
    end component;
    
    signal btn_s, leds_s: std_logic_vector(1 downto 0);
    signal clk_s: std_logic := '0';
    
begin

    test: btn_fsm2 port map(btn_s, clk_s, leds_s);

    process
    begin
    
        wait for 10 ns;
        clk_s <= not(clk_s);
    
    end process;

    process
    begin
    
        btn_s <= "00";
        wait for 1 ns;
        
        btn_s <= "11";
        wait for 7 ns;
    
        btn_s <= "01";
        wait for 6 ns;
    
        btn_s <= "11";
        wait for 6 ns;
    
        btn_s <= "10";
        wait for 13 ns;
    
        btn_s <= "11";
        wait for 4 ns;
    
        btn_s <= "00";
        wait for 10 ns;
    
    end process;

end Behavioral;

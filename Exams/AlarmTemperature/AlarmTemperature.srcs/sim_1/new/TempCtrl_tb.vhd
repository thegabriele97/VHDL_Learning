library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TempCtrl_tb is
end TempCtrl_tb;

architecture Behavioral of TempCtrl_tb is

    component TempCtrl is
        port(
            clk, rst: in std_logic;
            ct, wt: in std_logic_vector(15 downto 0);
            alarm: out std_logic
        );
    end component;

    for DUT: TempCtrl use entity work.TempCtrl(fsmd);

    signal clk, rst, alarm: std_logic := '0';
    signal ct, wt: std_logic_vector(15 downto 0);

begin

    DUT: TempCtrl port map(clk, rst, ct, wt, alarm);

    process
    begin

        wait for 0.5 ns;
        clk <= not clk;

    end process;

    process
    begin

        rst <= '1';
        wait for 1 ns;

        rst <= '0';
        wait for 1 ns;

        wt <= x"0003";
        ct <= x"0001";
        wait for 5 ns;

        ct <= x"0004";
        wait for 3 ns;
        
        ct <= x"0010";
        wait for 6 ns;

        wait;

    end process;

end Behavioral;

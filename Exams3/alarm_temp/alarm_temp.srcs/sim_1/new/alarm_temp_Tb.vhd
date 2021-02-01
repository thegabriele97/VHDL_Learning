library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alarm_temp_Tb is
end alarm_temp_Tb;

architecture Behavioral of alarm_temp_Tb is

    component alarm_temp is
        port(
            clk, rst: in std_logic;
            CT, WT: in std_logic_vector(15 downto 0);
            alarm: out std_logic
        );
    end component;

    for DUT: alarm_temp use entity work.alarm_temp(fsmd);

    signal clk, rst, alarm: std_logic := '1';
    signal ct, wt: std_logic_vector(15 downto 0);

begin

    DUT: alarm_temp port map(clk, rst, ct, wt, alarm);

    process
    begin
        
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    begin
    
        rst <= '1';
        wt <= x"0016";
        wait for 1 ns;
        
        rst <= '0';
        ct <= x"0010";
        wait for 1 ns;
    
        ct <= x"0021";
        wait for 1 ns;

        ct <= x"0020";
        wait for 1 ns;

        ct <= x"0006";
        wait for 1 ns;

        ct <= x"0010";
        wait for 1 ns;

        ct <= x"0020";
        wait for 1 ns;        

        ct <= x"002a";
        wait for 1 ns;
        
        ct <= x"000a";
        wait for 1 ns;
    
        ct <= x"000b";
        wait for 1 ns;
    
        ct <= x"0014";
        wait for 1 ns;
        
        ct <= x"0010";
        wait for 1 ns;
        
        ct <= x"0012";
        wait for 1 ns;                    
    
        ct <= x"0035";
        wait for 1 ns;
        
        ct <= x"0025";
        wait for 1 ns;            
    
        ct <= x"0014";
        wait for 1 ns;    
    
        ct <= x"0020";
        wait for 1 ns;    
    
        ct <= x"0014";
        wait for 1 ns;    
    
        ct <= x"001a";
        wait for 1 ns;    
    
        ct <= x"0010";
        wait for 1 ns;    
    
        wait;
    
    end process;

end Behavioral;

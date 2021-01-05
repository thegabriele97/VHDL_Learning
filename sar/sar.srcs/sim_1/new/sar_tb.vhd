library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sar_tb is
--  Port ( );
end sar_tb;

architecture Behavioral of sar_tb is

    component SAR is
        generic(
            nbits			: integer := 2;
            reg_siz		: integer := 2
        );
        
        port(
            clk			: in std_logic;
            rst			: in std_logic;
            
            --Start of conversion
            soc			: in std_logic;
            
            --End of conversion
            eoc			: out std_logic;
            
            --Comparator input
            comp_in		: in std_logic;
            
            --Data output: last conversion
            data			: out std_logic_vector((nbits-1) downto 0);
            
            --Data output: to DAC
            DAC_data		: out std_logic_vector((nbits-1) downto 0)
            
        );
    end component;

    signal clk, rst, soc, eoc, compin: std_logic := '0';
    signal data, dac: std_logic_vector(6 downto 0);

begin

    DUT: SAR generic map(7, 3) port map(clk, rst, soc, eoc, compin, data, dac);
    
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
        
        compin <= '0';
        soc <= '1';
        wait until eoc = '1';
        
        soc <= '0';
        wait;
    
    end process;

end Behavioral;

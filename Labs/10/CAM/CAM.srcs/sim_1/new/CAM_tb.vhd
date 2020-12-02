library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CAM_tb is
end CAM_tb;

architecture Behavioral of CAM_tb is

    component CAM is
        generic(
            m: integer := 2;
            p: integer := 16;
            n: integer := 3
        );
        port(
            clk, rst, wr_en: in std_logic;
            key_in: in std_logic_vector((p-1) downto 0);
            hit: out std_logic;
            w_data: in std_logic_vector((n-1) downto 0);
            data: out std_logic_vector((n-1) downto 0)
        );
    end component;
    
    constant p: integer := 16;
    constant n: integer := 3;
    
    signal clk, rst, wr_en, hit: std_logic := '0';
    signal data, w_data: std_logic_vector((n-1) downto 0);
    signal key_in: std_logic_vector((p-1) downto 0);

begin

    DUT: CAM port map(clk, rst, wr_en, key_in, hit, w_data, data);

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
        
        key_in <= x"0F0F";
        wr_en <= '0';
        wait for 1 ns;
        
        key_in <= x"FFFF";
        w_data <= "010";
        wr_en <= '1';
        wait for 1 ns;
        
        wr_en <= '0';
        wait for  3 ns;
        
        key_in <= x"0F0F";
        w_data <= "011";
        wr_en <= '1';
        wait for 1 ns;
        
        wr_en <= '0';
        wait for  3 ns;
        
        key_in <= x"FFFF";
        wr_en <= '0';
        wait for 6 ns;
    
        key_in <= x"0F0F";
        w_data <= "000";
        wr_en <= '1';
        wait for 1 ns;
        
        wr_en <= '0';
        wait for  3 ns;
        
        wait for 1 ns;
        key_in <= x"5555";
        w_data <= "000";
        wr_en <= '1';
        wait for 1 ns;
        
        wr_en <= '0';
        wait for  3 ns;
    
        key_in <= x"ABAB";
        w_data <= "111";
        wr_en <= '1';
        wait for 1 ns;
        
        wr_en <= '0';
        wait for  3 ns;
        
        key_in <= x"EEEE";
        w_data <= "100";
        wr_en <= '1';
        wait for 1 ns;
        
        wr_en <= '0';
        wait for  3 ns;
        
        key_in <= x"0F0F";
        wr_en <= '0';
        wait for 5 ns;
       
        key_in <= x"EEEE";
        wr_en <= '0';
        wait for 5 ns;
        
        wait;
    
    end process;

end Behavioral;

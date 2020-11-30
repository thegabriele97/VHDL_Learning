library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fifo_tb is
end fifo_tb;

architecture Behavioral of fifo_tb is

    component fifo is
        generic (
            m: integer := 4;
            n: integer := 8
        );
        port (
            clk, rst, wr, rd: in std_logic;
            full, empty: out std_logic;
            r_data: out std_logic_vector((n-1) downto 0);
            w_data: in std_logic_vector((n-1) downto 0)
        );
    end component;
    
    constant m: integer := 3;
    constant n: integer := 16;
    
    signal clk, rst, wr, rd, full, empty: std_logic := '0';
    signal r_data, w_data: std_logic_vector((n-1) downto 0);

begin

    DUT: fifo generic map(m, n) port map(clk, rst, wr, rd, full, empty,r_data, w_data);

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
        assert empty = '1' report "empty not 1 after reset";
        
        w_data <= x"0a0a";
        wr <= '1';
        wait for 1 ns;
        assert empty = '0' report "empty not 0 after write";
        
        w_data <= x"0b0b";
        wr <= '1';
        wait for 1 ns;
        
        w_data <= x"0c0c";
        wr <= '1';
        wait for 1 ns;
        
        rd <= '1';
        wait for 1 ns;
        
        for i in 0 to 6 loop
            rd <= '0';
            w_data <= std_logic_vector(TO_UNSIGNED(13 + i, 8) & TO_UNSIGNED(13 + i, 8));
            wait for 1 ns;
        end loop;
        
        rd <= '1';
        wait for 1 ns;
        
        w_data <= x"0b0b";
        wr <= '1';
        wait for 1 ns;
        
        for i in 0 to 9 loop
            wr <= '0';
            rd <= '1';
            wait for 1 ns;
        end loop;
        
        rd <= '0';
        wr <= '0';
        wait;
    
    end process;

end Behavioral;

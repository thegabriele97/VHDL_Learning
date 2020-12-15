library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity matrix_dot_mul_tb is
end matrix_dot_mul_tb;

architecture Behavioral of matrix_dot_mul_tb is

    component matrix_dot_mul is
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            
            wreq        : in std_logic;
            wgrant      : out std_logic;
            bs          : in std_logic;
            
            goreq       : in std_logic;
            gogrant     : out std_logic;
            
            rdreq       : in std_logic;
            rdgrant     : out std_logic;
            
            finish      : out std_logic;
            
            row         : in std_logic_vector(4 downto 0);
            col         : in std_logic_vector(4 downto 0);
            data        : inout std_logic_vector(31 downto 0) 
        );
    end component;    

    signal clk: std_logic := '0';
    signal rst, wreq, wgrant, bs, goreq, gogrant, rdreq, rdgrant, finish: std_logic;
    signal row, col: std_logic_vector(4 downto 0);
    signal data: std_logic_vector(31 downto 0);

begin

    DUT: matrix_dot_mul port map(clk, rst, wreq, wgrant, bs, goreq, gogrant, rdreq, rdgrant, finish, row, col, data);
    
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
        
        wreq <= '1';
        bs <= '0';
        wait until wgrant = '1';
        
        row <= "00000";
        col <= "00000";
        data <= x"00052000";
        wait for 2 ns;
        
        row <= "00000";
        col <= "00001";
        data <= x"00042000";
        wait for 2 ns;
        
        row <= "00001";
        col <= "00001";
        data <= x"000d2b85";
        wreq <= '0';     
        wait for 2 ns;
       
        wreq <= '1';
        bs <= '1';
        wait until wgrant = '1';
        
        row <= "00000";
        col <= "00000";
        data <= x"00044000";
        wait for 2 ns;
        
        row <= "00001";
        col <= "00000";
        data <= x"00042000";
        wait for 2 ns;
        
        row <= "00001";
        col <= "00001";
        data <= x"002a3d70";
        wreq <= '0';
        wait for 2 ns;
        
        data <= (others => 'Z');
        goreq <= '1';
        wait until finish = '1';
        
        goreq <= '0';
        rdreq <= '1';
        wait for 1 ns;
        
        row <= "00000";
        col <= "00000";
        wait for 2 ns;
        
        row <= "00001";
        col <= "00001";
        wait for 2 ns;
        
        rdreq <= '0';
        
        wait;
        
    
    end process;

end Behavioral;

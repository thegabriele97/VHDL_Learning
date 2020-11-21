library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoder_tb is
end encoder_tb;

architecture Behavioral of encoder_tb is

    component encoder is
        port(
            clk, rst, data, valid: in std_logic;
            output: out std_logic
        );
    end component;

    signal clk, data_clk, rst, data, valid, output: std_logic := '0';

begin

    DUT: encoder port map(clk, rst, data, valid, output);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;
    
    process
        
        type v_type is array(0 to 6) of std_logic;
        variable stream: v_type := "0010011";
    
    begin
    
        data <= 'Z';
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        for i in 0 to 6 loop
            data <= stream(i);
            wait for 0.1 ns;
            
            valid <= '1';
            data_clk <= '0';
            wait for 0.9 ns;
            
            data_clk <= '1';
            wait for 1 ns;
        end loop;
            
        valid <= '0';
        wait;
    
    end process;

end Behavioral;

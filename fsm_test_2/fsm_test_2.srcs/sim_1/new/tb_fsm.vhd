library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm is
end tb_fsm;

architecture Behavioral of tb_fsm is

    component fsm is
        port(
            clk, rst, b: in std_logic;
            x: out std_logic
        );
    end component;
    
    signal clk, rst, b, x: std_logic := '0';
    
begin

    DUT: fsm port map(clk, rst, b, x);
    
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
        assert x = '0' report "x shall be 0 after reset";
        
        for i in 0 to 1 loop
        
            b <= '1';
            wait for 2 ns;
            assert x = '1' report "x shall be 1 after 2 clk cycles end activation";
            
            b <= '0';
            wait for 1 ns;
            assert x = '0' report "x shall be 0 after 3 clock cycles from activation";
    
        end loop;
        
        b <= '1';
        for i in 0 to 1 loop
        
            wait for 2 ns;
            assert x = '1' report "x shall be 1 after 2 clk cycles end activation";
            
            wait for 1 ns;
            assert x = '0' report "x shall be 0 after 3 clock cycles from activation";
    
        end loop;
        b <= '0';

        wait;
    
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity bcd_tb is
end bcd_tb;

architecture Behavioral of bcd_tb is
    
    component bcd is  -- change bcd_v to bcd if you want to test bcd.vhd entity
        port(
            clk, rst, x: in std_logic;
            z: out std_logic
        );
    end component;

    for DUT: bcd use entity work.bcd(proc2);

    signal clk, rst, x: std_logic := '0';
    signal z: std_logic;

begin

    DUT: bcd port map(clk, rst, x, z); -- change bcd_v to bcd if you want to test bcd.vhd entity
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
        
        --variable testv: std_logic_vector(0 to 17) := "000101111011001000";
        variable testv: std_logic_vector(0 to 17) := "000100100010101111";
        variable storage: std_logic_vector(3 downto 0) := x"0";
    
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns; 
        
        wait for 0.5 ns;
        for i in testv'range loop
            x <= testv(i);
            wait for 1 ns;
            
            storage(0) := storage(1);
            storage(1) := storage(2);
            storage(2) := storage(3);
            storage(3) := testv(i);
            
            if (unsigned(storage) > 9) then
                assert z = '1' report "errroooooooooorrr";
            else
                assert z = '0' report "errroooooooooorrr";
            end if;
            
        end loop;
    
        wait;
    
    end process;

end Behavioral;

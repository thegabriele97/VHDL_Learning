library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_file is
end tb_file;

architecture Behavioral of tb_file is

    component fsm is
        port(
            p, clk, rst: in std_logic;
            r: out std_logic
        );
    end component;

    for test: fsm use entity work.fsm(behav_1proc_sync); 
    
    signal p, clk, rst, r: std_logic := '0';

begin

    test: fsm port map(p, clk, rst, r);
    
    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;
    
    process
        
        variable in_line, res_line: line;
        variable in_bit, res_bit: bit;
        file inputs, results: text;
    
    begin
    
        file_open(results, "results.mem", read_mode);
        file_open(inputs, "inputs.mem", read_mode);
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        p <= '0';
        wait for 1 ns;
        
        while ((not endfile(inputs)) and (not endfile(results))) loop
            
            readline(inputs, in_line);
            readline(results, res_line);
            
            for i in in_line'range loop
            
                read(in_line, in_bit);
                read(res_line, res_bit);
            
                p <= to_stdulogic(in_bit);
                wait for 1 ns;
                assert r = to_stdulogic(res_bit);
            
            end loop;
        
        end loop;
    
        file_close(inputs);
        file_close(results);
        wait;
    
    end process;

end Behavioral;

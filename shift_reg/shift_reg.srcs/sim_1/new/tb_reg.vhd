library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;

entity tb_reg is
end tb_reg;

architecture Behavioral of tb_reg is

    component shl_reg is
        generic (
            nbits: integer := 4
        );    
        port(
            d_in, sh_enable, clk, rst: in std_logic;
            d_out: inout std_logic_vector((nbits-1) downto 0)
        );
    end component;

    signal d_in, sh_en, rst, clk: std_logic := '0';
    signal d_out: std_logic_vector(3 downto 0);

begin

    test: shl_reg generic map(4) port map(d_in, sh_en, clk, rst, d_out);

    process
    begin
    
        wait for 10 ns;
        clk <= not(clk);
    
    end process;
    
    process
    
        variable textline: line;
        variable readbit: bit;
        file datafile: text;
    
    begin
    
        rst <= '1';
        wait for 5 ns;
        rst <= '0';
        wait for 2 ns;
        
        file_open(datafile, "data.mem", read_mode);
        while not(endfile(datafile)) loop
        
            readline(datafile, textline);
            for i in textline'range loop
                read(textline, readbit);
                
                d_in <= to_stdulogic(readbit);
                sh_en <= '1';
                wait for 10 ns;
            
            end loop;
            
            readline(datafile, textline);
            for i in textline'range loop
                read(textline,readbit);
                if (i < 4) then
                    assert d_out(i) = to_stdulogic(readbit);
                end if;
            end loop;
        
        end loop;
        
        file_close(datafile);
        wait;
    
    end process;

end Behavioral;

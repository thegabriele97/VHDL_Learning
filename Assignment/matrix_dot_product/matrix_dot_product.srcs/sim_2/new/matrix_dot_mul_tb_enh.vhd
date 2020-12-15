library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.numeric_std.all;

entity matrix_dot_mul_tb_enh is
end matrix_dot_mul_tb_enh;

architecture Behavioral of matrix_dot_mul_tb_enh is

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
        
        variable line_v : line;
        file read_file : text;
        variable read_int : integer;
        variable read_string: string(1 to 10); --Max integer on 32 bit is 4294967295: 10 chars
    
        variable got, expect: real;
    
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for 1 ns;
        
        wreq <= '1';
        bs <= '0';
        wait until wgrant = '1';
        
        file_open(read_file, "mat0.mem", read_mode);
        for i in 0 to 31 loop
            for j in 0 to 31 loop
                readline(read_file, line_v);
                read(line_v, read_int);
              
                row <= std_logic_vector(TO_UNSIGNED(i, row'length));
                col <= std_logic_vector(TO_UNSIGNED(j, col'length));
                data <= std_logic_vector(TO_UNSIGNED(read_int, data'length));
                wait for 2 ns;
            end loop;
        end loop;

        file_close(read_file);

        wreq <= '0';
        wait until wgrant = '0';
        
        wreq <= '1';
        bs <= '1';
        wait until wgrant = '1';
        
        file_open(read_file, "mat1.mem", read_mode);
        for i in 0 to 31 loop
            for j in 0 to 31 loop
                readline(read_file, line_v);
                read(line_v, read_int);
              
                row <= std_logic_vector(TO_UNSIGNED(i, row'length));
                col <= std_logic_vector(TO_UNSIGNED(j, col'length));
                data <= std_logic_vector(TO_UNSIGNED(read_int, data'length));
                wait for 2 ns;
            end loop;
        end loop;

        file_close(read_file);
        
        wreq <= '0';
        wait until wgrant = '0';
        
        data <= (others => 'Z');
        goreq <= '1';
        wait until finish = '1';
        
        goreq <= '0';
        rdreq <= '1';
        wait until rdgrant = '1';
        
        file_open(read_file, "mat2.mem", read_mode);
        for i in 0 to 31 loop
            for j in 0 to 31 loop
                readline(read_file, line_v);
                read(line_v, read_string);
              
                row <= std_logic_vector(TO_UNSIGNED(i, row'length));
                col <= std_logic_vector(TO_UNSIGNED(j, col'length));
                wait for 2 ns;
                
                got := real(to_integer(unsigned(data)));
                expect := real'value(read_string);
                assert got = expect
                report "ERROR! Result not equal to the expected one! (" & integer'image(i) & "," & integer'image(j) & "): " & real'image(got) & " : " & real'image(expect);
                
            end loop;
        end loop;

        file_close(read_file);
        
        rdreq <= '0';
        wait until rdgrant = '0'; 
        
        wait;
        
    
    end process;

end Behavioral;
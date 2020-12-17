----------------------------------------------------------------------------------
-- Company:     Politecnico di Torino
-- Engineer:    La Greca Salvatore Gabriele
-- 
-- Create Date: 14.12.2020 20:29:46
-- Design Name: Controller
-- Module Name: Controller
-- Project Name: Matrix Dot Product
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity matrix_dot_mul is
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
end matrix_dot_mul;

architecture struct of matrix_dot_mul is

    component Controller is
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
            
            rowext      : in std_logic_vector(4 downto 0);
            colext      : in std_logic_vector(4 downto 0);
            dataext     : out std_logic_vector(31 downto 0);
            
            row0        : out std_logic_vector(4 downto 0);
            col0        : out std_logic_vector(4 downto 0);
            data0       : inout std_logic_vector(31 downto 0);
            cs0         : out std_logic;
            rw0         : out std_logic;
            oe0         : out std_logic;
            
            row1        : out std_logic_vector(4 downto 0);
            col1        : out std_logic_vector(4 downto 0);
            data1       : inout std_logic_vector(31 downto 0);
            cs1         : out std_logic;
            rw1         : out std_logic;
            oe1         : out std_logic;
            
            row2        : out std_logic_vector(4 downto 0);
            col2        : out std_logic_vector(4 downto 0);
            data2       : inout std_logic_vector(31 downto 0);
            cs2         : out std_logic;
            rw2         : out std_logic;
            oe2         : out std_logic
        );
    end component;
    
    component MXM is
        generic(
            r           : integer;
            c           : integer;
            w           : integer
        );
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            
            rw          : in std_logic;
            oe          : in std_logic;
            cs          : in std_logic;
            
            row         : in std_logic_vector((r-1) downto 0);
            col         : in std_logic_vector((c-1) downto 0);
            data        : inout std_logic_vector((w-1) downto 0)
        );
    end component;    

    constant r, c: integer := 5;
    constant w: integer := 32;
    
    signal row0: std_logic_vector(4 downto 0);
    signal col0: std_logic_vector(4 downto 0);
    signal data0: std_logic_vector(31 downto 0);
    signal cs0: std_logic;
    signal rw0: std_logic;
    signal oe0: std_logic;
    
    signal row1: std_logic_vector(4 downto 0);
    signal col1: std_logic_vector(4 downto 0);
    signal data1: std_logic_vector(31 downto 0);
    signal cs1: std_logic;
    signal rw1: std_logic;
    signal oe1: std_logic;
    
    signal row2: std_logic_vector(4 downto 0);
    signal col2: std_logic_vector(4 downto 0);
    signal data2, data_buffered: std_logic_vector(31 downto 0);
    signal cs2: std_logic;
    signal rw2: std_logic;
    signal oe2: std_logic;
    
    signal read_grant_int, write_grant_int: std_logic;

begin

    data0 <= data when (write_grant_int = '1') else (others => 'Z');
    data1 <= data when (write_grant_int = '1') else (others => 'Z');
    
    Matrix0: MXM generic map(r, c, w) port map(
        clk => clk,
        rst => rst,
        rw => rw0,
        oe => oe0,
        cs => cs0,
        row => row0,
        col => col0,
        data => data0
    );
    
    Matrix1: MXM generic map(r, c, w) port map(
        clk => clk,
        rst => rst,
        rw => rw1,
        oe => oe1,
        cs => cs1,
        row => row1,
        col => col1,
        data => data1
    );
    
    Matrix2: MXM generic map(r, c, w) port map(
        clk => clk,
        rst => rst,
        rw => rw2,
        oe => oe2,
        cs => cs2,
        row => row2,
        col => col2,
        data => data2
    );
    
    Ctrl: Controller port map(
        clk => clk,
        rst => rst,
        wreq => wreq,
        wgrant => write_grant_int,
        bs => bs,
        goreq => goreq,
        gogrant => gogrant,
        rdreq => rdreq,
        rdgrant => read_grant_int,
        finish => finish,
        rowext => row,
        colext => col,
        dataext => data_buffered,
        row0 => row0,
        col0 => col0,
        data0 => data0,
        row1 => row1,
        col1 => col1,
        data1 => data1,
        row2 => row2,
        col2 => col2,
        data2 => data2,
        cs0 => cs0,
        cs1 => cs1,
        cs2 => cs2,
        rw0 => rw0,
        rw1 => rw1,
        rw2 => rw2,
        oe0 => oe0,
        oe1 => oe1,
        oe2 => oe2
    );

    data <= data_buffered when (read_grant_int = '1') else (others => 'Z');
    rdgrant <= read_grant_int;
    wgrant <= write_grant_int;

end struct;

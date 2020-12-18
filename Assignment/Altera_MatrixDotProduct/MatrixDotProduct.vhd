library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MatrixDotProduct is
	port(
		clk_in	: in std_logic;
		rst_n		: in std_logic;
		
		rdreq_n	: in std_logic;
		goreq_n	: in std_logic;
		
		ncol_n	: in std_LOGIC;
		nrow_n	: in std_LOGIC;
		
		wgrant_n	: out std_logic;
		rdgrant_n: out std_logic;
		gogrant_n: out std_logic;
		finish_n	: out std_logic;
		
		beep		: out std_LOGIC;
		
		seg		: out std_logic_vector(7 downto 0);
		dig		: out std_logic_vector(3 downto 0)
		
	);
end entity;

architecture struct of MatrixDotProduct is

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

	component pll_altera IS
		PORT
		(
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC 
		);
	END component;
	
	component DigitalTubeHexController is
		port(
			clk: in std_logic;
			rst: in std_logic;
			
			data: in std_logic_vector(15 downto 0);
			
			seg: out std_logic_vector(7 downto 0);
			dig: out std_logic_vector(3 downto 0)		
		);
	end component;
	
	component debouncer is
		port(
			clk: in std_logic;
			rst: in std_logic;
			
			bi: in std_logic;
			bo: out std_logic
		);
	end component;
	
	component RowReader is
		port(
			clk		: in std_logic;
			rst		: in std_logic;
			
			nrow_req	: in std_logic;
			ncol_req	: in std_logic;
			
			row		: out std_logic_vector(4 downto 0);
			col		: out std_logic_vector(4 downto 0)
		);
	end component;
	
	signal clk_5khz, clk_1hz: std_LOGIC;
	signal rst, rdreq, goreq, wgrant, gogrant, rdgrant, finish: std_logic;
	signal irow, icol: std_logic_vector(4 downto 0);
	signal idata: std_logic_vector(31 downto 0);
	signal iseg: std_logic_vector(7 downto 0);
	signal nrow, ncol, nrow_req, ncol_req: std_LOGIC;
	
	signal curr_cnt, next_cnt: std_logic_vector(15 downto 0);
	
begin
	
	pll0: pll_altera port map(clk_in, clk_5khz);
	
	MdM: matrix_dot_mul port map(clk_in, rst, '0', wgrant, '0', goreq, gogrant, rdreq, rdgrant, finish, irow, icol, idata);
	HexCtrl: DigitalTubeHexController port map(clk_5khz, rst, idata(23 downto 8), iseg, dig);
	
	debouncer0: Debouncer port map(clk_5khz, rst, nrow, nrow_req);
	debouncer1: Debouncer port map(clk_5khz, rst, ncol, ncol_req);
	RowReader0: RowReader port map(clk_5khz, rst, nrow_req, ncol_req, irow, icol);
	
	
	rst <= not rst_n;
	rdreq <= not rdreq_n;
	goreq <= not goreq_n;
	
	wgrant_n <= not wgrant;
	rdgrant_n <= not rdgrant;
	gogrant_n <= not gogrant;
	finish_n <= not finish;
	
	seg <= not iseg;
	
	nrow <= not nrow_n;
	ncol <= not ncol_n;
	beep <= '0';
	
	
	--1 Hz clock generation
	next_cnt <= std_logic_vector((unsigned(curr_cnt) + 1)) when (unsigned(curr_cnt) /= 5000) else (others => '0');
	clk_1hz <= '1' when (unsigned(curr_cnt) = 5000) else '0';

	process(clk_5khz)
	begin
	
		if (rising_edge(clk_5khz)) then
			if (rst = '1') then
				curr_cnt <= (others => '0');
			else
				curr_cnt <= next_cnt;
			end if;
		end if;
	
	end process;
	--until here
	
end struct;
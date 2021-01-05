library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prescaler is
	generic(
		nbits: integer
	);
	port(
		clk, rst: in std_logic;
		
		nv: in std_logic_vector((nbits-1) downto 0);
		load: in std_logic;
		
		done: out std_logic := '0';
		tc: out std_logic
	);
end entity;

architecture behav of prescaler is

	type fsm_state is ( wait_nv, well_done );
	signal curr_state, next_state: fsm_state;
	
	signal curr_cnt, next_cnt: std_logic_vector((nbits-1) downto 0);
	signal curr_div, next_div: std_logic_vector((nbits-1) downto 0);

begin
	
	tc <= '1' when (unsigned(curr_cnt) = 1) else '0';
	
	process(curr_state, nv, load, curr_cnt, curr_div)
	begin
	   
	    next_state <= curr_state;
		done <= '0';
		
		case curr_state is
		
			when wait_nv =>
			    
			    next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
			    if (unsigned(curr_cnt) = unsigned(curr_div)) then
			        next_cnt <= (others => '0');
			    end if;
			
				if (load = '1') then
					next_div <= nv;
					next_cnt <= (others => '0');
					next_state <= well_done;
				end if;
				
			when well_done =>
				done <= '1';
				next_state <= wait_nv;
		
		end case;
		
	end process;
	
	process(clk, rst)
	begin
	
		if (rst = '1') then
			curr_cnt <= (others => '0');
			curr_div <= std_logic_vector(TO_UNSIGNED(1, curr_div'length));
			curr_state <= wait_nv;
		elsif (rising_edge(clk)) then
			curr_cnt <= next_cnt;
			curr_div <= next_div;
			curr_state <= next_state;
		end if;
	
	end process;
	
end behav;

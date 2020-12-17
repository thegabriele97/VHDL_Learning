library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RowReader is
	port(
		clk		: in std_logic;
		rst		: in std_logic;
		
		nrow_req	: in std_logic;
		ncol_req	: in std_logic;
		
		row		: out std_logic_vector(4 downto 0);
		col		: out std_logic_vector(4 downto 0)
	);
end entity;

architecture behav of RowReader is

	type fsm_state is ( wait_something, inc_row, inc_col );
	signal curr_state, next_state: fsm_state;

	signal curr_row, next_row, curr_col, next_col: std_logic_vector(4 downto 0);
	
begin

	row <= curr_row;
	col <= curr_col;

	process(curr_state, curr_row, curr_col, nrow_req, ncol_req)
	begin
	
			next_state <= curr_state;
			next_col <= curr_col;
			next_row <= curr_row;
			
			case curr_state is
			
				when wait_something =>
					--next_row <= "00000";
					--next_col <= "00000";
				
					if (nrow_req = '1') then
						next_state <= inc_row;
					elsif (ncol_req = '1') then
						next_state <= inc_col;
					end if;
					
				when inc_row =>
					next_row <= std_logic_vector(unsigned(curr_row) + 1);
					next_state <= wait_something;
					
				when inc_col =>
					next_col <= std_logic_vector(unsigned(curr_col) + 1);
					next_state <= wait_something;
			
				when others =>
					next_state <= wait_something;
			
			end case;
	
	end process;
	
	process(clk)
	begin
	
		if (rising_edge(clk)) then
			if (rst = '1') then
				curr_state <= wait_something;
				curr_row <= "00000";
				curr_col <= "00000";
			else
				curr_state <= next_state;
				curr_row <= next_row;
				curr_col <= next_col;
			end if;
		end if;
	
	end process;

end behav;
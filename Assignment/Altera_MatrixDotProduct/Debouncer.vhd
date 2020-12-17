library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
	port(
		clk: in std_logic;
		rst: in std_logic;
		
		bi: in std_logic;
		bo: out std_logic
	);
end entity;

architecture behav of debouncer is

	type fsm_state is ( wait_bi, now_on, wait_bi_off );
	signal curr_state, next_state: fsm_state;
	
begin

	process(curr_state, bi)
	begin
	
		next_state <= curr_state;
		bo <= '0';
		
		case curr_state is
		
			when wait_bi =>
				if (bi = '1') then
					next_state <= now_on;
				end if;
				
			when now_on =>
				bo <= '1';
				next_state <= wait_bi_off;
			
			when wait_bi_off =>
				if (bi = '0') then
					next_state <= wait_bi;
				end if;
				
			when others =>
				next_state <= wait_bi;
		
		end case;
	
	end process;

	process(clk)
	begin
	
		if (rising_edge(clk)) then
			if (rst = '1') then
				curr_state <= wait_bi;
			else
				curr_state <= next_state;
			end if;
		end if;
	
	end process;

end behav;
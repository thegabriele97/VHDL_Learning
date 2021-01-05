library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SAR is
	generic(
		nbits			: integer := 2;
		reg_siz		: integer := 2
	);
	
	port(
		clk			: in std_logic;
		rst			: in std_logic;
		
		--Start of conversion
		soc			: in std_logic;
		
		--End of conversion
		eoc			: out std_logic;
		
		--Comparator input
		comp_in		: in std_logic;
		
		--Data output: last conversion
		data			: out std_logic_vector((nbits-1) downto 0);
		
		--Data output: to DAC
		DAC_data		: out std_logic_vector((nbits-1) downto 0)
		
	);
end entity;

architecture hlsm of SAR is

	type fsm_state is ( wait_soc, try_1, confirm_bit, done );
	signal curr_state, next_state: fsm_state;
	
	signal curr_iter, next_iter: std_logic_vector((reg_siz - 1) downto 0);
	signal curr_dac, next_dac, curr_conv, next_conv: std_logic_vector((nbits-1) downto 0);
	
begin

	DAC_data <= curr_dac;
	data <= curr_conv;

	process(curr_state, curr_iter, curr_dac, curr_conv, soc, comp_in)
	begin
	
		next_state <= curr_state;
		next_iter <= curr_iter;
		next_dac <= curr_dac;
		next_conv <= curr_conv;
		eoc <= '0';
		
		case curr_state is
		
			when wait_soc =>
				next_iter <= std_logic_vector(TO_UNSIGNED(nbits-1, next_iter'length));
				next_dac <= (others => '0');
				
				if (soc = '1') then
					next_state <= try_1;
				end if;
				
			when try_1 =>
				next_dac(TO_INTEGER(unsigned(curr_iter))) <= '1';
				next_state <= confirm_bit;
				
			when confirm_bit =>
				next_dac(TO_INTEGER(unsigned(curr_iter))) <= comp_in;
				next_iter <= std_logic_vector(unsigned(curr_iter) - 1);
				
				if (unsigned(curr_iter) > 0) then
					next_state <= try_1;
				elsif (unsigned(curr_iter) = 0) then
					next_state <= done;
				end if;
				
			when done =>
				next_conv <= curr_dac;
				eoc <= '1';
				next_state <= wait_soc;
		
		end case;
	
	end process;

	process(clk, rst)
	begin
	
		if (rst = '1') then
			curr_state <= wait_soc;
			curr_dac <= (others => '0');
			curr_conv <= (others => '0');
			curr_iter <= (others => '0');
		elsif (rising_edge(clk)) then
			curr_state <= next_state;
			curr_dac <= next_dac;
			curr_iter <= next_iter;
			curr_conv <= next_conv;
		end if;
	
	end process;
	

end hlsm;
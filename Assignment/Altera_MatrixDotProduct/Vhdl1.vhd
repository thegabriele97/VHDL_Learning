library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DigitalTubeHexController is
	port(
		clk: in std_logic;
		rst: in std_logic;
		
		data: in std_logic_vector(15 downto 0);
		
		seg: out std_logic_vector(7 downto 0);
		dig: out std_logic_vector(3 downto 0)		
	);
end entity;

architecture behav of digitalTubeHexController is

	signal cnt: std_logic_vector(1 downto 0);
	signal curr_data: std_logic_vector(3 downto 0);
	
begin
	
	seg(6 downto 0) <= "0111111" when (unsigned(curr_data) = 0) else
							 "0000110" when (unsigned(curr_data) = 1) else
							 "1011011" when (unsigned(curr_data) = 2) else
							 "1001111" when (unsigned(curr_data) = 3) else
							 "1100110" when (unsigned(curr_data) = 4) else
							 "1101101" when (unsigned(curr_data) = 5) else
							 "1111101" when (unsigned(curr_data) = 6) else
							 "0000111" when (unsigned(curr_data) = 7) else
							 "1111111" when (unsigned(curr_data) = 8) else
							 "1101111" when (unsigned(curr_data) = 9) else
							 "1110111" when (unsigned(curr_data) = 10) else
							 "1111100" when (unsigned(curr_data) = 11) else
							 "1011000" when (unsigned(curr_data) = 12) else
							 "1011110" when (unsigned(curr_data) = 13) else
							 "1111001" when (unsigned(curr_data) = 14) else
							 "1110001" when (unsigned(curr_data) = 15);

	seg(7) <= '1' when (unsigned(cnt) = 2) else '0';
							 
	dig <= "1110" when (unsigned(cnt) = 0) else
			 "1101" when (unsigned(cnt) = 1) else
			 "1011" when (unsigned(cnt) = 2) else
			 "0111" when (unsigned(cnt) = 3);
	
	curr_data <= data((4*to_integer(unsigned(cnt)) + 3) downto 4*to_integer(unsigned(cnt)));
	
	process(clk)
	begin
	
		if (rising_edge(clk)) then
		
			if (rst = '1') then
				cnt <= (others => '0');
			else	
				cnt <= std_logic_vector(unsigned(cnt) + 1);
			end if;
		
		end if;
	
	end process;

end behav;
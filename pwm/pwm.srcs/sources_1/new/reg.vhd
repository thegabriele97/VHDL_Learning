library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity reg is
    generic(
        nbits: integer
    );
    port(
        clk, rst: in std_logic;
        
        nv: in std_logic_vector((nbits-1) downto 0);
        load: in std_logic;
        
        done: out std_logic := '0';
        val: out std_logic_vector((nbits-1) downto 0)
    );
end reg;

architecture newarch of reg is

    signal curr_reg, next_reg: std_logic_vector((nbits-1) downto 0);

begin

    val <= curr_reg;
    next_reg <= nv when (load = '1') else curr_reg;
    done <= '0' when (next_reg /= curr_reg) else '1';

    process(clk, rst)
    begin

        if (rst = '1') then
            curr_reg <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_reg <= next_reg;
        end if;
    
    end process;

end newarch;

architecture Behavioral of reg is

    type fsm_state is ( wait_nv, well_done );
    signal curr_state, next_state: fsm_state;
    
    signal curr_val, next_val: std_logic_vector((nbits-1) downto 0);

begin
    
    val <= curr_val;
    
    process(curr_state, nv, load)
	begin
	
	    next_state <= curr_state;
		done <= '0';
		
		case curr_state is
		
			when wait_nv =>
				if (load = '1') then
					next_val <= nv;
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
            curr_val <= (others => '0');
            curr_state <= wait_nv;
        elsif (rising_edge(clk)) then
            curr_val <= next_val;
            curr_state <= next_state;
        end if;
    
    end process;

end Behavioral;

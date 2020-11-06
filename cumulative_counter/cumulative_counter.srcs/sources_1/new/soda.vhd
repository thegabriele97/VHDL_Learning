library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity soda is
    port(
        c, clk, rst: in std_logic;
        s, a: in std_logic_vector(7 downto 0);
        amt: out std_logic_vector(7 downto 0);
        d: out std_logic
    );
end soda;

architecture Behavioral of soda is

    type fsm_state is ( init, wt, add, disp );
    signal curr_state, next_state: fsm_state;
    signal curr_amt, next_amt: std_logic_vector(7 downto 0);

begin

    process(curr_state, curr_amt, c)
    begin
        
        next_state <= curr_state;
        next_amt <= curr_amt;
        d <= '0';
        
        case curr_state is
            when init =>
                next_amt <= (others => '0');
                next_state <= wt;
                
            when wt =>
                if (c = '1') then
                    next_state <= add;
                end if;
            
            when add =>
                next_amt <= std_logic_vector(unsigned(curr_amt) + 1);
                next_state <= wt;
                
            when disp =>
                d <= '1';
                next_state <= init;
                
        end case;
                
    
    end process;

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
        
            if (rst <= '1') then
                curr_state <= init;
                curr_amt <= (others => '0');
            else
                curr_state <= next_state;
                curr_amt <= next_amt;
            end if;
            
        end if;
    
    end process;

end Behavioral;

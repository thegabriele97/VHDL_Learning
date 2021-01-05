library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity logarithm is
    port(
        clk, rst, start: in std_logic;
        x: in std_logic_vector(15 downto 0);
        l: out std_logic_vector(3 downto 0);
        done: out std_logic
    );
end logarithm;

architecture hlsm of logarithm is

    type fsm_state is ( wait_start, check, calc, ready );
    signal curr_state, next_state: fsm_state;

    signal curr_r0, next_r0, curr_x, next_x: std_logic_vector(16 downto 0);
    signal curr_log, next_log: std_logic_vector(3 downto 0);

begin

    l <= curr_log;

    process(curr_state, curr_r0, curr_x, curr_log, x, start)
    begin
    
        next_state <= curr_state;
        next_x <= curr_x;
        next_r0 <= curr_r0;
        next_log <= curr_log;
        done <= '0';
    
        case curr_state is
        
            when wait_start =>
                next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
                next_log <= (others => '1');
                next_x <= '0' & x;
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (unsigned(curr_r0) > unsigned(curr_x)) then
                    next_state <= ready;
                end if;
                
            when calc =>
                next_r0 <= curr_r0((curr_r0'length-2) downto 0) & '0';
                next_log <= std_logic_vector(unsigned(curr_log) + 1);
                next_state <= check;
                
            when ready =>
                done <= '1';
                next_state <= wait_start;
            
            when others =>
                next_state <= wait_start;
        
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_start;
                curr_r0 <= (others => '0');
                curr_x <= (others => '0');
                curr_log <= (others => '0');
            else
                curr_state <= next_state;
                curr_r0 <= next_r0;
                curr_x <= next_x;
                curr_log <= next_log;
            end if;
        end if;
    
    end process;

end hlsm;

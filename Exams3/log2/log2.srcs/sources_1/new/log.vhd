library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity log is
    port(
        clk, rst, start: in std_logic;
        X: in std_logic_vector(15 downto 0);
        done: out std_logic;
        L: out std_logic_vector(3 downto 0)
    );
end log;

architecture hlsm of log is

    type fsm_State is ( wait_start, calc, ready );
    signal curr_state, next_state: fsm_state;
    signal curr_x, next_x: std_logic_vector(15 downto 0);
    signal curr_r0, next_r0: std_logic_vector(3 downto 0);
    signal curr_r1, next_r1: std_logic_vector(16 downto 0);
    signal curr_r2, next_r2: std_logic_vector(3 downto 0);

begin

    process(curr_state, curr_x, curr_r0, curr_r1, x, start, curr_r2)
    begin
    
        next_state <= curr_state;
        next_x <= curr_x;
        next_r0 <= curr_r0;
        done <= '0';
        next_r1 <= curr_r1;
        next_r2 <= curr_r2;
    
        case curr_state is
        
            when wait_start =>
                next_r0 <= (others => '1');
                next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
                next_x <= x;
                
                if (start = '1') then
                    next_state <= calc;
                end if;
                
            when calc =>
                next_r2 <= curr_r0;
                next_r0 <= std_logic_vector(unsigned(curr_r0) + 1);
                next_r1 <= curr_r1(15 downto 0) & '0';
                
                if (unsigned(curr_r1) > unsigned(curr_x)) then
                    next_state <= ready;
                end if;
        
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
                curr_x <= (others => '0');
                curr_r0 <= (others => '0');
                curr_r1 <= (others => '0');
                curr_r2 <= (others => '0');
            else
                curr_state <= next_state;
                curr_x <= next_x;
                curr_r0 <= next_r0;
                curr_r1 <= next_r1;
                curr_r2 <= next_r2;
            end if;
        
        end if;
    
    end process;
    
    L <= curr_r2;

end hlsm;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity log is
    generic(
        n: integer := 4
    );
    port(
        clk, rst, start: in std_logic;
        x: in std_logic_vector((2**n-1) downto 0);
        l: out std_logic_vector(n downto 0);
        ready: out std_logic
    );
end log;

architecture Behavioral of log is

    type fsm_state is ( wait_start, calc, ultimate, done );
    signal curr_state, next_state: fsm_state;
    signal curr_x, next_x: std_logic_vector((2**n-1) downto 0);
    signal curr_r1, next_r1: std_logic_vector(2**n downto 0);
    signal curr_iter, next_iter: std_logic_vector(n downto 0);

begin

    l <= curr_iter;
    
    process(curr_state, curr_x, curr_iter, curr_r1, start, x)
    begin
    
        next_state <= curr_state;
        next_x <= curr_x;
        next_iter <= curr_iter;
        next_r1 <= curr_r1;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_x <= x;
                next_iter <= std_logic_vector(TO_UNSIGNED(0, next_iter'length));
                next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
                next_state <= calc;
                
                if (start = '1') then
                    next_state <= calc;
                end if;

            when calc =>
                next_r1 <= curr_r1((2**n-1) downto 0) & '0'; --r1 <<= 1
                next_iter <= std_logic_vector(unsigned(curr_iter) + 1);
                
                if (unsigned(curr_r1((2**n-1) downto 0) & '0') >= unsigned(x)) then
                    next_state <= ultimate;
                end if;
        
            when ultimate =>
                next_iter <= std_logic_vector(unsigned(curr_iter) - 1);
                next_state <= done;
        
            when done =>
                ready <= '1';
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
                curr_iter <= (others => '0');
                curr_r1 <= (others => '0');
            else
                curr_state <= next_state;
                curr_x <= next_x;
                curr_iter <= next_iter;
                curr_r1 <= next_r1;
            end if;
         end if;
    
    end process;

end Behavioral;

architecture fsmd of log is

    signal x: integer;

begin

    x <= std_logic_vector(to_unsigned())

end fsmd;

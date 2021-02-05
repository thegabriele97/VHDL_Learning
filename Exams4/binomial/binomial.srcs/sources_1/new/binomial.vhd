library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity binomial is
    port(
        clk, rst, start: in std_logic;
        n, k: in std_logic_vector(2 downto 0);
        data_out: out std_logic_vector(5 downto 0);
        ready: out std_logic
    );
end binomial;

architecture hlsm of binomial is

    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_r0, next_r0: std_logic_vector(15 downto 0);
    signal curr_r1, next_r1: std_logic_vector(12 downto 0);
    signal curr_n, next_n, curr_k, next_k: std_logic_vector(2 downto 0);
    signal curr_r2, next_r2: std_logic_vector(15 downto 0);

begin

    data_out <= curr_r2(5 downto 0);
    
    process(curr_state, curr_n, curr_k, curr_r0, curr_r1, curr_r2, n, k, start)
    begin
    
        next_state <= curr_state;
        next_n <= curr_n;
        next_k <= curr_k;
        next_r0 <= curr_r0;
        next_r1 <= curr_r1;
        next_r2 <= curr_r2;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_n <= n;
                next_k <= k;
                next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
                next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
                next_r2 <= std_logic_vector(TO_UNSIGNED(1, next_r2'length));
        
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
           
            when check =>
                next_state <= calc;
                if (unsigned(curr_n) = unsigned(curr_k) or unsigned(curr_k) = 0) then
                    next_state <= done;
                end if;
                
            when calc =>
                next_r0 <= std_logic_vector(unsigned(curr_n) * unsigned(curr_r0(12 downto 0)));
                next_r1 <= std_logic_vector(unsigned(curr_k) * unsigned(curr_r1(9 downto 0)));
                next_r2 <= std_logic_vector(unsigned(curr_r0) / unsigned(curr_r1));
                next_n <= std_logic_vector(unsigned(curr_n) - 1);
                next_k <= std_logic_vector(unsigned(curr_k) - 1);
        
                if (unsigned(curr_k) = 0) then
                    next_state <= done;
                end if;
           
            when others =>
                next_state <= wait_start;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
            curr_r2 <= (others => '0');
            curr_n <= (others => '0');
            curr_k <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
            curr_r2 <= next_r2;
            curr_n <= next_n;
            curr_k <= next_k;
        end if;
    
    end process;

end hlsm;

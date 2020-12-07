library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity binomial is
    port(
        clk, rst, start: in std_logic;
        n, k: in std_logic_vector(2 downto 0);
        ready: out std_logic;
        data_out: out std_logic_vector(5 downto 0)
    );
end binomial;

architecture Behavioral of binomial is

    type fsm_state is ( wait_start, check, calc, ultimate, done );
    signal curr_state, next_state: fsm_state;
    signal curr_n, next_n, curr_k, next_k, curr_iter, next_iter: std_logic_vector(2 downto 0);
    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(11 downto 0);

begin

    data_out <= curr_r0(5 downto 0);

    process(curr_state, curr_r0, curr_r1, curr_n, curr_k, curr_iter, start, n)
    begin
    
        next_state <= curr_state;
        next_n <= curr_n;
        next_k <= curr_k;
        next_r0 <= curr_r0;
        next_r1 <= curr_r1;
        next_iter <= curr_iter;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_n <= n;
                next_r0 <= "000000000" & n;
                next_r1 <= "000000000" & k;
                next_k <= k;
                next_iter <= "001";
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                
                next_state <= calc;
                if (curr_n = curr_k(2 downto 0) or unsigned(curr_k) = 0) then
                    next_r0 <= "000000000001";
                    next_state <= done;
                end if;
                
            when calc =>
                next_r0 <= std_logic_vector(TO_UNSIGNED(TO_INTEGER(unsigned(curr_r0) * (unsigned(curr_n) - unsigned(curr_iter))), next_r0'length));
                next_r1 <= std_logic_vector(TO_UNSIGNED(TO_INTEGER(unsigned(curr_r1) * (unsigned(curr_k) - unsigned(curr_iter))), next_r1'length));
                --next_r0 <= std_logic_vector(TO_UNSIGNED(TO_INTEGER(unsigned(curr_r0) * (unsigned(curr_n) - 1)/(unsigned(curr_k) - 1)), next_r0'length));
                next_iter <= std_logic_vector(unsigned(curr_iter) + 1);
                
                if (unsigned(curr_iter) = (unsigned(curr_k) - 1)) then
                    next_state <= ultimate;
                end if;
        
            when ultimate =>
                next_r0 <= std_logic_vector(TO_UNSIGNED(TO_INTEGER(unsigned(curr_r0) / unsigned(curr_r1)), next_r0'length));
                next_state <= done;
            
            when done =>
                ready <= '1';
                next_state <= wait_start;
            
            when others =>
                next_state <= wait_start;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
            curr_n <= (others => '0');
            curr_k <= (others => '0');
            curr_iter <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_n <= next_n;
            curr_k <= next_k;
            curr_iter <= next_iter;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;

end Behavioral;

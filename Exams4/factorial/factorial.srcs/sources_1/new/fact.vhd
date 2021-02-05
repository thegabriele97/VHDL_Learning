library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fact is
    port(
        clk, rst, start: in std_logic;
        n: in std_logic_vector(2 downto 0);
        data_out: out std_logic_vector(12 downto 0);
        ready: out std_logic
    );
end fact;

architecture hlsm of fact is

    type fsm_state is ( wait_start, done, check, calc );
    signal curr_state, next_state: fsm_state;
    signal curr_r0, next_r0: std_logic_vector(15 downto 0);
    signal curr_n, next_n: std_logic_vector(2 downto 0);

begin

    data_out <= curr_r0(12 downto 0);
    
    process(curr_state, curr_r0, curr_n, n, start)
    begin
    
        next_state <= curr_state;
        next_r0 <= curr_r0;
        next_n <= curr_n;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_n <= n;
                next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
                
            when check =>
                next_state <= calc;
                if (curr_n = "000") then
                    next_state <= done;
                end if;
                
            when calc =>
                next_r0 <= std_logic_vector(unsigned(curr_n) * unsigned(curr_r0(12 downto 0)));
                next_n <= std_logic_vector(unsigned(curr_n) - 1);
                
                if (curr_n = "001") then
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
            curr_n <= (others => '0');
            curr_r0 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_n <= next_n;
            curr_r0 <= next_r0;
        end if;
    
    end process;

end hlsm;

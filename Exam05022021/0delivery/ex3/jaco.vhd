library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity jaco is
    port(
        clk, rst, start: in std_logic;
        n: in std_logic_vector(3 downto 0);
        ready: out std_logic;
        J: out std_logic_vector(13 downto 0)
    );
end entity;

architecture hlsm of jaco is

    type fsm_state is ( wait_start, done, check, calc );
    signal curr_state, next_state: fsm_state;
    signal curr_n, next_n: std_logic_vector(3 downto 0);
    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(13 downto 0);
    
begin

    J <= curr_r0;
    
    process(curr_state, curr_r0, curr_r1, curr_n, n, start)
    begin
    
        next_state <= curr_state;
        next_r0 <= curr_r0;
        next_n <= curr_n;
        next_r1 <= curr_r1;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_r0 <= (others => '0');
                next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
                next_n <= n;
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (curr_n = x"0") then
                    next_state <= done;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
                
            when calc =>
                next_r0 <= curr_r1;
                next_r1 <= std_logic_vector(unsigned(curr_r1) + unsigned(curr_r0(12 downto 0) & '0'));
                next_n <= std_logic_vector(unsigned(curr_n) - 1);
        
                if (curr_n = x"1") then
                    next_state <= done;
                end if;
                
            when others =>
                next_state <= wait_start;
        
        end case;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_Start;
            curr_n <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_n <= next_n;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;

end hlsm;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity locker is
    port(
        clk, rst, x: in std_logic;
        u: out std_logic
    );
end locker;

architecture Behavioral of locker is

    type fsm_state is ( a, b, c, d, e, f );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, x)
    begin
    
        next_state <= curr_state;
        u <= '0';
    
        case curr_state is
        
            when a =>
                if (x = '0') then
                    next_state <= b;
                end if;
            
            when b =>
                next_state <= a;
                if (x = '1') then
                    next_state <= c;
                end if;
                
            when c =>
                next_state <= a;
                if (x = '0') then
                    next_state <= d;
                end if;
        
            when d =>
                next_state <= a;
                if (x = '1') then
                    next_state <= e;
                end if;
                
            when e =>
                next_state <= a;
                if (x = '1') then
                    next_state <= f;
                end if;
        
            when f =>
                u <= '1';
                next_state <= a;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= a;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;
    
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity filter is
    port(
        clk, rst, x: in std_logic;
        z: out std_logic
    );
end filter;

architecture fsm of filter is

    type fsm_state is ( a, b, c, d, e, f );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, x)
    begin
    
        next_state <= curr_state;
        z <= '0';
        
        case curr_state is
        
            when a =>
                next_state <= b;
                if (x = '0') then
                    next_state <= e;
                end if;
                
            when b =>
                next_state <= d;
                if (x = '0') then
                    next_state <= c;
                end if;
                
            when c =>
                z <= '1';
                next_state <= d;
                if (x = '0') then
                    next_state <= f;
                end if;
                
            when d =>
                z <= '1';
                if (x = '0') then
                    next_state <= c;
                end if;
                
            when e =>
                next_state <= b;
                if (x = '0') then
                    next_state <= f;
                end if;
                
            when f =>
                if (x = '1') then
                    next_state <= b;
                end if;
                
            when others =>
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

end fsm;

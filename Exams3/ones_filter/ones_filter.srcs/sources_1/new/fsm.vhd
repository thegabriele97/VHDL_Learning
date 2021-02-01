library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    port(
        clk, rst, x: in std_logic;
        z: out std_logic
    );
end fsm;

architecture two of fsm is

    type fsm_state is ( a, b, c );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, x)
    begin
    
        next_state <= curr_state;
        z <= '0';
    
        case curr_state is
        
            when a =>
                if (x = '1') then
                    next_state <= b;
                end if;
                
            when b =>
                next_state <= c;
                if (x = '0') then
                    next_state <= a;
                end if;
                
            when c =>
                z <= '1';
                if (x = '0') then
                    next_state <= a;
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

end two;

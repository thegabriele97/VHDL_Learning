library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity median_filter is
    port(
        clk, rst, x: in std_logic;
        z: out std_logic
    );
end median_filter;

architecture Behavioral of median_filter is

    type fsm_state is ( a, b, c, d, e, bp );
    signal curr_state, next_state: fsm_state;
 
begin

    process(curr_state, x)
    begin
    
        next_state <= curr_state;
        
        case curr_state is
        
            when a =>
                z <= '1';
                
                if (x = '1') then
                    next_state <= b;
                elsif (x = '0') then
                    next_state <= e;
                end if;
                
            when b =>
                z <= '1';
                
                if (x = '0') then
                    next_state <= c;
                end if;
                
            when c =>
                z <= '1';
                
                if (x = '1') then
                    next_state <= d;
                elsif (x = '0') then
                    next_state <= e;
                end if;
                
            when d =>
                z <= '1';
                
                if (x = '1') then
                    next_state <= a;
                elsif (x = '0') then
                    next_state <= c;
                end if;
                
            when e =>
                z <= '0';
                
                if (x = '1') then
                    next_state <= bp;
                end if;
                
            when bp =>
                z <= '0';
                
                if (x = '0') then
                    next_state <= c;
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

end Behavioral;

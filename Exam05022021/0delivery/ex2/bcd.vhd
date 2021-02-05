library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd is
    port(
        clk, rst, x: in std_logic;
        z: out std_logic
    );
end bcd;

architecture proc2 of bcd is

    type fsm_state is ( c, d, e, f, g );
    signal curr_state, next_state: fsm_state;

begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= c;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

    process(curr_state, x)
    begin
    
        next_state <= curr_state;
        z <= '0';
        
        case curr_state is
        
            when c =>
                next_state <= d;
                if (x = '1') then
                    next_state <= e;
                end if;
                
            when d =>
                next_state <= g;
                if (x = '1') then
                    z <= '1';
                    next_state <= f;
                end if;
                
            when e =>
                next_state <= d;
                if (x = '1') then
                    z <= '1';
                    next_state <= f;
                end if;
                
            when f =>
                if (x = '1') then
                    z <= '1';
                elsif (x = '0') then
                    next_state <= d;
                end if;
                
            when g =>
                if (x = '1') then
                    next_state <= e;
                end if;
                
            when others =>
                next_state <= c;
            
        end case;
    
    end process;

end proc2;

architecture proc1 of bcd is

    type fsm_state is ( c, d, e, f, g );
    signal state: fsm_state;

begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                state <= c;
                z <= '0';
            else
                z <= '0';
                case state is
                    
                    when c =>
                        state <= d;
                        if (x = '1') then
                            state <= e;
                        end if;
                    
                    when d =>
                        state <= g;
                        if (x = '1') then
                            state <= f;
                            z <= '1';
                        end if;
                        
                    when e =>
                        state <= d;
                        if (x = '1') then
                            z <= '1';
                            state <= f;
                        end if;
                        
                    when f =>
                        if (x = '1') then
                            z <= '1';
                        elsif (x = '0') then
                            state <= d;
                        end if;
                        
                    when g =>
                        if (x = '1') then
                            state <= e;
                        end if;
                        
                    when others =>
                        state <= c;
                    
                end case;
            end if;
        end if;
    
    end process;

end proc1;
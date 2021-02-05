library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seq is
    port(
        clk, rst, en, x: in std_logic;
        z: out std_logic_vector(1 downto 0)
    );
end seq;

architecture fsm of seq is

    type fsm_state is ( a, b, c, d, e, f );
    signal curr_state, next_state: fsm_state;

begin

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= a;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

    process(curr_state, en, x)
    begin
    
        next_state <= curr_state;
        z <= "00";
        
        case curr_state is
        
            when a =>
                if (en = '1') then
                    next_state <= b;
                    if (x = '0') then
                        next_state <= e;
                    end if;
                end if;
                
            when b =>
                next_state <= c;
                if (en = '1' and x = '0') then
                    next_state <= e;
                elsif (en = '0') then
                    next_state <= a;
                end if;
                
            when c =>
                if (en = '0') then
                    next_state <= a;
                elsif (en = '1') then
                    next_state <= e;
                    if (x = '1') then
                        z <= "10";
                        next_state <= d;
                    end if;
                end if;
                
            when d =>
                if (en = '0') then
                    next_state <= a;
                else
                    next_state <= e;
                    if (x = '1') then
                        z <= "10";
                        next_state <= d;
                    end if;
                end if;
                
            when e =>
                if (en = '0') then
                    next_state <= a;
                else
                    next_state <= b;
                    if (x = '0') then
                        z <= "01";
                        next_state <= f;
                    end if;
                end if;
                
            when f =>
                if (en = '0') then 
                    next_state <= a;
                else
                    next_state <= b;
                    if (x = '0') then
                        z <= "01";
                        next_state <= f;
                    end if;
                end if;
                
            when others =>
                next_state <= a;
            
        end case;
        
    end process;

end fsm;

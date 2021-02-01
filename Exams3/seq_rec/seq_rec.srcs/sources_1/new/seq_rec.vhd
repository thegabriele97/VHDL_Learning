library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity seq_rec is
    port(
        clk, rst, en, x: in std_logic;
        z: out std_logic_vector(1 downto 0)
    );
end seq_rec;

architecture fsm of seq_rec is

    type fsm_state is ( a, b, c, d, e, f, g );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, en, x)
    begin

        next_state <= curr_state;
        z <= "00";
        
        case curr_state is
        
            when a =>
                if (en = '1') then
                    if (x = '0') then
                        next_state <= b;
                    elsif (x = '1') then
                        next_state <= d;
                    end if;
                end if;
        
            when b =>
                if (en = '1') then
                    if (x = '0') then
                        z <= "01";
                        next_state <= c;
                    elsif (x = '1') then
                        next_state <= d;
                    end if;
                elsif (en = '0') then
                    next_state <= a;
                end if;
                
            when c =>
                if (en = '1') then
                    if (x = '0') then
                        z <= "01";
                    elsif (x = '1') then
                        next_state <= d;
                    end if;
                elsif (en = '0') then
                    next_state <= a;
                end if;
                
            when d =>
                if (en = '1') then
                    if (x = '0') then
                        next_state <= b;
                    elsif (x = '1') then
                        next_state <= e;
                    end if;
                elsif (en = '0') then
                    next_state <= a;
                end if;
                
            when e =>
                if (en = '1') then
                    if (x = '0') then
                        next_state <= b;
                    elsif (x = '1') then
                        z <= "10";
                        next_state <= f;
                    end if;
                elsif (en = '0') then
                    next_state <= a;
                end if;   
                
            when f =>
                if (en = '1') then
                    if (x = '0') then
                        next_state <= b;
                    elsif (x = '1') then
                        z <= "10";
                    end if;
                elsif (en = '0') then
                    next_state <= a;
                end if;                   
        
            when others =>
                next_state <= a;
        
        end case;   

    end process;
    
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

end fsm;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seq is
    port(
        clk, rst, en, x: in std_logic;
        z: out std_logic_vector(1 downto 0)
    );
end seq;

architecture fsm of seq is

    type fsm_state is ( wait_seq, got_0, got_0_again, got_1, got_1_again, same_1 );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, en, x)
    begin
    
        next_state <= curr_state;
        z <= "00";
        
        case curr_state is
        
            when wait_seq =>
                if (en = '1' and x = '0') then
                    next_state <= got_0;
                elsif (en = '1' and x = '1') then
                    next_state <= got_1;
                end if;
                
            when got_0 =>
                if (en = '0') then
                    next_state <= wait_seq;
                elsif (en = '1' and x = '0') then
                    --z <= "01";
                    next_state <= got_0_again;
                elsif (en = '1' and x = '1') then
                    next_state <= got_1;
                end if;
            
            when got_0_again =>
                if (en = '0') then
                    next_state <= wait_seq;
                elsif (en = '1' and x = '0') then
                    z <= "01";
                elsif (en = '1' and x = '1') then
                    next_state <= got_1;
                end if;
                
            when got_1 =>
                if (en = '0') then
                    next_state <= wait_seq;
                elsif (en = '1' and x = '1') then
                    next_state <= got_1_again;
                elsif (en = '1' and x = '0') then
                    next_state <= got_0;
                end if;
             
            when got_1_again =>
                if (en = '0') then
                    next_state <= wait_seq;
                elsif (en = '1' and x = '1') then
                    --z <= "10";
                    next_state <= same_1;
                elsif (en = '1' and x = '0') then
                    next_state <= got_0;
                end if;
                
            when same_1 =>
                if (en = '0') then
                    next_state <= wait_seq;
                elsif (en = '1' and x = '1') then
                    z <= "10";
                elsif (en = '1' and x = '0') then
                    next_state <= got_0;
                end if;
            
            when others =>
                next_state <= wait_seq;
        
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_seq;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end fsm;

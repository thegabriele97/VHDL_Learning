library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    port(
        clk, reset, start, stop: in std_logic;
        run: out std_logic
    );
end fsm;

architecture behav_2proc of fsm is

    type fsm_type is ( wait_s, on_s );
    signal curr_state, next_state: fsm_type;

begin

    process(curr_state, start, stop)
    begin
    
        next_state <= curr_state;
        run <= '0';
        
        case curr_state is
        
            when wait_s =>
                if (start = '1') then
                    next_state <= on_s;
                end if;
                
            when on_s =>
                run <= '1';
                
                if (stop = '1') then
                    next_state <= wait_s;
                end if;
                
            when others => 
                next_state <= wait_s;
        
        end case;
    
    end process;

    process(clk, reset)
    begin
    
        if (reset = '1') then
            curr_state <= wait_s;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end behav_2proc;

architecture behav_1proc_diff of fsm is

    type fsm_type is ( wait_s, on_s );
    signal state: fsm_type;

begin

    process(clk, reset)
    begin
    
        if (reset = '1') then
            state <= wait_s;
        elsif (rising_edge(clk)) then

            run <= '0';
            
            case state is
            
                when wait_s =>
                    if (start = '1') then
                        state <= on_s;
                    end if;
                    
                when on_s =>
                    run <= '1';
                    
                    if (stop = '1') then
                        state <= wait_s;
                    end if;
                    
                when others => 
                    state <= wait_s;
            
            end case;
            
        end if;
    
    end process;

end behav_1proc_diff;

architecture behav_1proc_eq of fsm is

    type fsm_type is ( wait_s, on_s );
    signal curr_state, next_state: fsm_type;

begin

    process(clk, reset, curr_state, start, stop)
    begin
    
        next_state <= curr_state;
        run <= '0';
        
        case curr_state is
        
            when wait_s =>
                if (start = '1') then
                    next_state <= on_s;
                end if;
                
            when on_s =>
                run <= '1';
                
                if (stop = '1') then
                    next_state <= wait_s;
                end if;
                
            when others => 
                next_state <= wait_s;
        
        end case;
    
        if (reset = '1') then
            curr_state <= wait_s;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end behav_1proc_eq;

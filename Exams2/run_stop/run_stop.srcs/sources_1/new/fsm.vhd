library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    port(
        clk, reset, start, stop: in std_logic;
        run: out std_logic
    );
end fsm;

architecture proc2 of fsm is

    type fsm_state is ( wait_start, go );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, start, stop)
    begin
    
        next_state <= curr_state;
        run <= '0';
        
        case curr_state is
        
            when wait_start =>
                if (start = '1') then
                    next_state <= go;
                end if;
                
            when go =>
                run <= '1';
                
                if (stop = '1') then
                    next_state <= wait_start;
                end if;
        
        end case;
    
    end process;

    process(clk, reset)
    begin
    
        if (reset = '1') then
            curr_state <= wait_start;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end proc2;

architecture proc1_diff of fsm is

    type fsm_state is ( wait_start, go );
    signal state: fsm_state;

begin

    process(clk, reset)
    begin
    
        if (reset = '1') then
            state <= wait_start;
        elsif (rising_edge(clk)) then
            
            run <= '0';
            
            case state is
                when wait_start =>
                    if (start = '1') then
                        state <= go;
                    end if;
                
                when go =>
                    run <= '1';
                    
                    if (stop = '1') then
                        state <= wait_start;
                    end if;
            end case;
            
        end if;
        
    end process;

end proc1_diff;

architecture proc1_same of fsm is

    type fsm_state is ( wait_start, go );
    signal curr_state, next_state: fsm_state;

begin

    process(clk, reset, curr_state, start, stop)
    begin
    
        if (reset = '1') then
            curr_state <= wait_start;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
        
        next_state <= curr_state;
        run <= '0';
        
        case curr_state is
        
            when wait_start =>
                if (start = '1') then
                    next_state <= go;
                end if;
                
            when go =>
                run <= '1';
                
                if (stop = '1') then
                    next_state <= wait_start;
                end if;
        
        end case;
    
    end process;

end proc1_same;
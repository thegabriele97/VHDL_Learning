library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sas is
    port(
        clk, Reset, Start, Stop: in std_logic;
        Run: out std_logic
    );
end sas;

architecture two of sas is

    type fsm_state is ( wait_start, wait_stop );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, Start, Stop)
    begin
    
        next_state <= curr_state;
        run <= '0';
        
        case curr_state is
        
            when wait_start =>
                if (Start = '1') then
                    next_state <= wait_stop;
                end if;
            
            when wait_stop =>
                Run <= '1';
                
                if (Stop = '1') then
                    next_state <= wait_start;
                end if;
                
            when others =>
                next_state <= wait_start;
        
        end case;
    
    end process;

    process(clk, Reset)
    begin
    
        if (Reset = '1') then
            curr_state <= wait_start;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end two;

architecture three of sas is
    
    type fsm_state is ( wst, wsp );
    signal state: fsm_state;

begin

    process(clk, Reset)
    begin
    
        if (Reset = '1') then
            state <= wst;
        elsif (rising_edge(clk)) then
            
            case state is
            
                when wst =>
                    if (Start = '1') then
                        state <= wsp;
                    end if;
                    
                    Run <= '0';
                    
                when wsp =>
                    Run <= '1';
                    
                    if (Stop = '1') then
                        state <= wst;
                    end if;
                    
                when others =>
                    state <= wst;
            
            end case;
        
        end if;
    
    end process;

end three;

architecture four of sas is
    
    type fsm_state is ( wst, wsp );
    signal curr_state, next_state: fsm_state;

begin

    process(clk, Reset, curr_state, Start, Stop)
    begin
    
        next_state <= curr_state;
        Run <= '0';
        
        case curr_state is
        
            when wst =>
                if (Start = '1') then
                    next_state <= wsp;
                end if;
                
            when wsp =>
                Run <= '1';
                
                if (Stop = '1') then
                    next_state <= wst;
                end if;
                
            when others =>
                next_state <= wst;
        
        end case;
    
        if (Reset = '1') then
            curr_state <= wst;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end four;
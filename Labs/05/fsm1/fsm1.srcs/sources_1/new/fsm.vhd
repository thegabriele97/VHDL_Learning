library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    port(
        p, clk, rst: in std_logic;
        r: out std_logic
    );
end fsm;

architecture behav_1proc_sync of fsm is
    
    type fsm_state is ( state_a, state_b, state_c, state_d );
    signal curr_state: fsm_state;

begin

    process(clk, rst, p)
    begin
        
        if (rst = '1') then
            curr_state <= state_a;
            r <= '0';
        elsif (rising_edge(clk))then
            r <= '0';
            case curr_state is
                    
                when state_a =>
                    if (p = '1') then
                        curr_state <= state_b;
                    end if;
                
                when state_b =>
                    if (p = '1') then
                        curr_state <= state_c;
                    end if;
                
                when state_c =>                
                    if (p = '1') then
                        curr_state <= state_d;
                    end if;
                 
                when state_d =>
                    r <= '1';
                    
                    if (p = '1') then
                        curr_state <= state_b;
                    elsif (p  = '0') then
                        curr_state <= state_a;
                    end if;
                    
                when others =>
                    curr_state <= state_a;
                    
                end case;
        end if;
        
    end process;

end behav_1proc_sync;

architecture behav_1proc of fsm is

    type fsm_state is ( state_a, state_b, state_c, state_d );
    signal curr_state, next_state: fsm_state;

begin

    process(clk, rst, p, curr_state)
    begin
    
    r <= '0';
    next_state <= curr_state;
    case curr_state is
            
        when state_a =>
            if (p = '1') then
                next_state <= state_b;
            end if;
        
        when state_b =>
            if (p = '1') then
                next_state <= state_c;
            end if;
        
        when state_c =>                
            if (p = '1') then
                next_state <= state_d;
            end if;
         
        when state_d =>
            r <= '1';
            
            if (p = '1') then
                next_state <= state_b;
            elsif (p  = '0') then
                next_state <= state_a;
            end if;
            
        when others =>
            next_state <= state_a;
            
        end case;
        
        if (rst = '1') then
            curr_state <= state_a;
            r <= '0';
        elsif (rising_edge(clk))then
            curr_state <= next_state;
        end if;
        
    end process;

end behav_1proc;

architecture behav_2proc of fsm is

    type fsm_state is ( state_a, state_b, state_c, state_d );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, p)
    begin
        
        r <= '0';
        next_state <= curr_state;
    
        case curr_state is
            
            when state_a =>
                if (p = '1') then
                    next_state <= state_b;
                end if;
            
            when state_b =>
                if (p = '1') then
                    next_state <= state_c;
                end if;
            
            when state_c =>                
                if (p = '1') then
                    next_state <= state_d;
                end if;
             
            when state_d =>
                r <= '1';
                
                if (p = '1') then
                    next_state <= state_b;
                elsif (p  = '0') then
                    next_state <= state_a;
                end if;
                
            when others =>
                next_state <= state_a;
            
        end case;
    end process;

    process(clk, rst)
    begin
        if (rst = '1') then
            curr_state <= state_a;
        elsif (rising_edge(clk))then
            curr_state <= next_state;
        end if;
    end process;

end behav_2proc;

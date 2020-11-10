library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detect is
    port(
        clk, rst, stb: in std_logic;
        edge_detected: out std_logic
    );
end edge_detect;

architecture Melay of edge_detect is

    type fsm_state is ( waiting, detected );
    signal curr_state, next_state: fsm_state;

begin

        process(curr_state, stb)
        begin
        
            case curr_state is
            
                when waiting =>
                    if (rising_edge(stb)) then
                        edge_detected <= '1';
                        next_state <= detected;
                    elsif (next_state /= detected) then
                        edge_detected <= '0';
                        next_state <= waiting;
                    end if;
            
                when detected =>
                    edge_detected <= '1';
                    next_state <= waiting;
            
                when others =>
                    next_state <= waiting;
            
            end case;
        
        end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= waiting;
        elsif (rising_edge(clk) or falling_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end Melay;

architecture Moore of edge_detect is

    type fsm_state is ( waiting, detected );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, stb)
    begin
    
        --next_state <= curr_state;
    
        case curr_state is
        
            when waiting =>
                edge_detected <= '0';
                
                if (rising_edge(stb)) then
                    next_state <= detected;
                end if;
                
            when detected =>
                edge_detected <= '1';
                next_state <= waiting;
                
            when others =>
                next_state <= waiting;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= waiting;
        elsif (rising_edge(clk) or (curr_state = detected and falling_edge(clk))) then
            curr_state <= next_state;
        end if;
    
    end process;

end Moore;

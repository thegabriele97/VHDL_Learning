library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoder is
    port(
        clk, rst, data, valid: in std_logic;
        output: out std_logic
    );
end encoder;

architecture Behavioral of encoder is

    type fsm_state is ( init, wait_valid, out_1, out_0 );
    signal curr_state, next_state: fsm_state;
    signal curr_firsthalf, next_firsthalf: std_logic;

begin

    process(curr_state, curr_firsthalf, valid, data)
    begin
    
        next_state <= curr_state;
        output <= '0';
        
        case curr_state is
        
            when init =>
                next_state <= wait_valid;
            
            when wait_valid =>
                next_firsthalf <= '0';
                
                if (valid = '1') then
                    if (data = '1') then
                        next_state <= out_1;
                    elsif (data = '0') then
                        next_state <= out_0;
                    end if;
                end if;
                
            when out_0 =>
                next_firsthalf <= '1';
                
                if (curr_firsthalf = '0') then
                    next_state <= out_1;
                elsif (curr_firsthalf = '1') then
                    if (valid = '1') then
                        
                        if (data = '1') then
                            next_state <= out_1;
                        elsif (data = '0') then
                            next_state <= out_0;
                        end if;
                        
                        next_firsthalf <= '0';
                    elsif (valid = '0') then
                        next_state <= wait_valid;
                    end if;
                end if;
                
            when out_1 =>
                output <= '1';
                next_firsthalf <= '1';
                
                if (curr_firsthalf = '0') then
                    next_state <= out_0;
                elsif (curr_firsthalf = '1') then
                    if (valid = '1') then
                        
                        if (data = '1') then
                            next_state <= out_1;
                        elsif (data = '0') then
                            next_state <= out_0;
                        end if;
                        
                        next_firsthalf <= '0';
                    elsif (valid = '0') then
                        next_state <= wait_valid;
                    end if;
                end if;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init;
            else
                curr_state <= next_state;
                curr_firsthalf <= next_firsthalf;
            end if;
        end if;
    
    end process;

end Behavioral;

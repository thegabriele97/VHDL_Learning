library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    port(
        updw, clk, rst: in std_logic;
        cnt: out std_logic_vector(3 downto 0) 
    );
end fsm;

architecture moore of fsm is

    type fsm_state is ( s0, s1, s2, s3 );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, updw)
    begin
    
        case curr_state is
        
            when s0 =>
                cnt <= "1000";
                
                if (updw = '0') then
                    next_state <= s3;
                elsif (updw = '1') then
                    next_state <= s1;
                end if;
                
            when s1 =>
                cnt <= "0100";
                
                if (updw = '0') then
                    next_state <= s0;
                elsif (updw = '1') then
                    next_state <= s2;
                end if;
                
            when s2 =>
                cnt <= "0010";
                
                if (updw = '0') then
                    next_state <= s1;
                elsif (updw = '1') then
                    next_state <= s3;
                end if;
            
            when s3 =>
                cnt <= "0001";
                
                if (updw = '0') then
                    next_state <= s2;
                elsif (updw = '1') then
                    next_state <= s0;
                end if; 
            
            when others =>
                next_state <= s0;
            
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= s0;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end moore;

architecture mealy of fsm is

    type fsm_state is ( s0, s1, s2, s3 );
    signal curr_state, next_state: fsm_state;
    
begin

    process(curr_state, updw)
    begin
    
        case curr_state is
        
            when s0 =>
                if (updw = '0') then
                    cnt <= "0001";
                    next_state <= s3;
                elsif (updw = '1') then
                    cnt <= "0100";
                    next_state <= s1;
                end if;
                
            when s1 =>
                if (updw = '0') then
                    cnt <= "1000";
                    next_state <= s0;
                elsif (updw = '1') then
                    cnt <= "0010";
                    next_state <= s2;
                end if;
                
            when s2 =>
                if (updw = '0') then
                    cnt <= "0100";
                    next_state <= s1;
                elsif (updw = '1') then
                    cnt <= "0001";
                    next_state <= s3;
                end if;
                
            when s3 =>
                if (updw = '0') then
                    cnt <= "0010";
                    next_state <= s2;
                elsif (updw = '1') then
                    cnt <= "1000";
                    next_state <= s0;
                end if;
        
            when others =>
                next_state <= s0;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= s0;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end mealy;

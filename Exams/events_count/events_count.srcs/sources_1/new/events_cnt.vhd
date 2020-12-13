library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity events_cnt is
    port(
        clk, rst, b: in std_logic;
        c: out std_logic_vector(15 downto 0) 
    );
end events_cnt;

architecture hlsm of events_cnt is

    type fsm_state is ( s_a, cnt_a, s_b, cnt_b );
    signal curr_state, next_state: fsm_state;
    signal curr_c, next_c: std_logic_vector(15 downto 0);

begin

    c <= curr_c;

    process(curr_state, curr_c, b)
    begin
    
        next_state <= curr_state;
        next_c <= curr_c;
    
        case curr_state is
        
            when s_a =>
                if (b = '1') then
                    next_state <= cnt_a;
                end if;
            
            when cnt_a =>
                next_c <= std_logic_vector(unsigned(curr_c) + 1);
                next_state <= s_b;
                
            when s_b =>
                if (b = '0') then
                    next_state <= cnt_b;
                end if;
            
            when cnt_b =>
                next_c <= std_logic_vector(unsigned(curr_c) + 1);
                next_state <= s_a;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= s_a;
            curr_c <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_c <= next_c;
        end if;
        
    end process;

end hlsm;

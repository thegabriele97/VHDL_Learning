library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity preamble is
    port(
        start: in std_logic;
        clk, rst: in std_logic;
        data_out: out std_logic
    );
end preamble;

architecture fsm of preamble is

    type fsm_state is ( wait_start, l_0, O_0, l_1, O_1, l_2, O_2, l_3, O_3 );
    signal curr_state, next_state: fsm_state;
    
begin

    process(curr_state, start)
    begin
    
        next_state <= curr_state;
        data_out <= 'Z';
    
        case curr_state is
        
            when wait_start =>
                if (start = '1') then
                    next_state <= l_0;
                end if;
                
            when l_0 =>
                data_out <= '1';
                next_state <= O_0;
        
            when O_0 =>
                data_out <= '0';
                next_state <= l_1;
                
            when l_1 =>
                data_out <= '1';
                next_state <= O_1;
                
            when O_1 =>
                data_out <= '0';
                next_state <= l_2;
        
            when l_2 =>
                data_out <= '1';
                next_state <= O_2;
        
            when O_2 =>
                data_out <= '0';
                next_state <= l_3;        
        
            when l_3 =>
                data_out <= '1';
                next_state <= O_3;
            
            when O_3 =>
                data_out <= '0';
                next_state <= wait_start;          
        
        end case;
    
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_start;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end fsm;

architecture hlsm of preamble is
    
    type fsm_state is ( wait_start, send_1, send_0 );
    signal curr_state, next_state: fsm_state;
    signal curr_cnt, next_cnt: std_logic_vector(1 downto 0);
    
begin
    
    process(curr_state, curr_cnt, start)
    begin
    
        next_state <= curr_state;
        data_out <= 'Z';
        
        case curr_state is
            
            when wait_start =>
                next_cnt <= "11";
                
                if (start = '1') then
                    next_state <= send_1;
                end if;
                
            when send_1 =>
                data_out <= '1';
                next_state <= send_0;
                
            when send_0 =>
                data_out <= '0';
                next_cnt <= std_logic_vector(unsigned(curr_cnt) - 1);
                
                next_state <= send_1;
                if (curr_cnt = "00") then
                    next_state <= wait_start;
                end if;
                
        end case;
        
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_start;
                curr_cnt <= (others => '0');
            else
                curr_state <= next_state;
                curr_cnt <= next_cnt;
            end if;
        end if;
        
    end process;

end hlsm;

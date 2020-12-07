library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity preamble is
    port(
        clk, rst, start: in std_logic;
        data_out: out std_logic
    );
end preamble;

architecture fsm of preamble is

    type fsm_state is ( wait_start, o0_0, o1_0, o0_1, o1_1, o0_2, o1_2, o0_3, o1_3 );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, start)
    begin
    
        next_state <= curr_state;
        data_out <= '0';
        
        case curr_state is
        
            when wait_start =>
               
                if (start = '1') then
                    next_state <= o0_0;
                end if;
                
            when o0_0 =>
                next_state <= o1_0;
            
            when o1_0 =>
                data_out <= '1';
                next_state <= o0_1;
                
            when o0_1 =>
                next_state <= o1_1;
                
            when o1_1 =>
                data_out <= '1';
                next_state <= o0_2;
                
            when o0_2 =>
                next_state <= o1_2;
                
            when o1_2 =>
                data_out <= '1';
                next_state <= o0_3;
                
            when o0_3 =>
                next_state <= o1_3;
                
            when o1_3 =>
                data_out <= '1';
                
                if (start = '0') then
                    next_state <= wait_start;
                elsif (start = '1') then
                    next_state <= o0_0;
                end if;
        
            when others =>
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

    type fsm_state is ( wait_start, out0, out1 );
    signal curr_state, next_state: fsm_state;
    signal curr_cnt, next_cnt: std_logic_vector(1 downto 0);

begin

    process(curr_state, curr_cnt, start)
    begin
    
        next_state <= curr_state;
        next_cnt <= curr_cnt;
        data_out <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_cnt <= (others => '0');
                
                if (start = '1') then
                    next_state <= out0;
                end if;
        
            when out0 =>
                next_state <= out1;
                
            when out1 =>
                data_out <= '1';
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
               
                next_state <= out0;
                if (curr_cnt = "11" and start = '0') then
                    next_state <= wait_start;
                end if;
            
            when others =>
                next_state <= wait_start;
        
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

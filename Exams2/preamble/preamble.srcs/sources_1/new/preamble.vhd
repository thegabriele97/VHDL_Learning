library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity preamble is
    port(
        clk, rst, start: in std_logic;
        data_out: out std_logic
    );
end preamble;

architecture fsm of preamble is

    type fsm_state is ( wait_start, f_1, f_0, s_1, s_0, t_1, t_0, ft_1, ft_0 );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, start)
    begin
    
        next_state <= curr_state;
        data_out <= '0';
        
        case curr_state is
        
            when wait_start =>
                if (start = '1') then
                    next_state <= f_1;
                end if;
                
            when f_1 =>
                data_out <= '1';
                next_state <= f_0;
            
            when f_0 =>
                data_out <= '0';
                next_state <= s_1;
                
            when s_1 =>
                data_out <= '1';
                next_state <= s_0;
            
            when s_0 =>
                data_out <= '0';
                next_state <= t_1;
                
            when t_1 =>
                data_out <= '1';
                next_state <= t_0;
                
            when t_0 =>
                data_out <= '0';
                next_state <= ft_1;
                
            when ft_1 =>
                data_out <= '1';
                next_state <= ft_0;
                
            when ft_0 =>
                data_out <= '0';
                next_state <= wait_start;
                
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
    
    type fsm_state is ( wait_start, s_1, s_0 );
    signal curr_state, next_state: fsm_state;
    
    signal curr_count, next_count: std_logic_vector(1 downto 0);

begin

    process(curr_state, curr_count, start)
    begin
    
        next_state <= curr_state;
        next_count <= curr_count;
        data_out <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_count <= "11";
                
                if (start = '1') then
                    next_state <= s_1;
                end if;
            
            when s_1 =>
                data_out <= '1';
                next_state <= s_0;
            
            when s_0 =>
                next_count <= std_logic_vector(unsigned(curr_count) - 1);
                
                next_state <= s_1;
                if (curr_count = "00") then
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
                curr_count <= (others => '0');
            else
                curr_state <= next_state;
                curr_count <= next_count;
            end if;
        end if;
        
    end process;    

end hlsm;

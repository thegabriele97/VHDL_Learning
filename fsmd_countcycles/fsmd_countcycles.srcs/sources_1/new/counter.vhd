library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity counter is
    port(
        clk, rst, m: in std_logic;
        cnt: out std_logic_vector(31 downto 0)
    );
end counter;

architecture Behavioral of counter is

    -- control signals
    signal cnt_up_enable, rst_counter: std_logic;
    
    -- controller signals
    type fsm_state is ( init, wait_m, cnt_up ); 
    signal curr_state, next_state: fsm_state;
    
    -- datapath signals
    signal int_counter: std_logic_vector(31 downto 0);


begin

    -- Datapath description
    process(clk, rst_counter)
    begin
    
        if (rising_edge(clk)) then
            if (rst_counter = '1') then
                int_counter <= (others => '0');
            elsif (cnt_up_enable = '1') then
                int_counter <= std_logic_vector(unsigned(int_counter) + 1);
            end if;
        end if;
    
    end process;
    
    cnt <= int_counter;
    
    -- Controller decription
    process(curr_state, m)
    begin
        
        next_state <= curr_state;
        rst_counter <= '0';
        cnt_up_enable <= '0';
        
        case curr_state is
        
            when init =>
                rst_counter <= '1';
                next_state <= wait_m;
                
            when wait_m =>
                
                if (m = '1') then
                    next_state <= cnt_up;
                end if;
                
            when cnt_up =>
                cnt_up_enable <= '1';
                
                if (m = '0') then
                    next_state <= wait_m;
                end if;
                
            when others =>
                next_state <= init;
        
        end case;
        
    end process;
    
    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end Behavioral;

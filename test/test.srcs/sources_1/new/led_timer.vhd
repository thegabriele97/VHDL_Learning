library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity led_timer is
    port(
        clk, rst: in std_logic;
        timer_val: in std_logic_vector(31 downto 0);
        led: out std_logic
    );
end led_timer;

architecture fsmd of led_timer is

    --datapath
    signal ld_timer_reg, ld_reg, cnt_end: std_logic;
    signal curr_reg, next_reg, timer_reg: std_logic_vector(31 downto 0);
    
    --controller
    type fsm_state is ( init, led_off, led_on );
    signal curr_state, next_state: fsm_state;
    
begin

    --datapath
    next_reg <= std_logic_vector(unsigned(curr_reg) - 1);
    cnt_end <= '1' when (unsigned(curr_reg) = 0) else '0';
 
    process(clk, ld_timer_reg, ld_reg)
    begin
     
        if (rising_edge(clk)) then
            if (ld = '1') then
                timer_reg <= std_logic_vector(unsigned(timer_val) - 1);
                curr_reg <= std_logic_vector(unsigned(timer_val) - 1);
            else
                curr_reg <= next_reg;
            end if;
        end if;
    
    end process;
    
    --controller
    process(curr_state, cnt_end)
    begin
    
        next_state <= curr_state;
        ld <= '0';
        led <= '0';
        
        case curr_state is
        
            when init =>
                ld <= '1';
                next_state <= led_off;
        
            when led_off =>
                
                if (cnt_end = '1') then
                    ld <= '1';
                    next_state <= led_on;
                end if;
                
            when led_on =>
                led <= '1';
            
                if (cnt_end = '1') then
                    ld <= '1';
                    next_state <= led_off;
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


end fsmd;

architecture hlsm of led_timer is

    type fsm_state is ( init, led_off, led_on );
    signal curr_state, next_state: fsm_state;
    signal curr_timer, next_timer, ld_val: std_logic_vector(31 downto 0);

begin

    process(curr_state, curr_timer)
    begin
    
        next_state <= curr_state;
        next_timer <= curr_timer;
        led <= '0';
        
        case curr_state is
        
            when init =>
                next_state <= led_off;
        
            when led_off =>
                next_timer <= std_logic_vector(unsigned(curr_timer) - 1);
                
                if (unsigned(curr_timer) = 0) then
                    next_state <= led_on;
                    next_timer <= ld_val;
                end if;
            
            when led_on =>
                led <= '1';
                next_timer <= std_logic_vector(unsigned(curr_timer) - 1);
                
                if (unsigned(curr_timer) = 0) then
                    next_state <= led_off;
                    next_timer <= ld_val;
                end if;
                
            when others =>
                next_state <= init;   
             
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init;
                curr_timer <= std_logic_vector(unsigned(timer_val) - 1);
                ld_val <= std_logic_vector(unsigned(timer_val) - 1);
            else
                curr_state <= next_state;
                curr_timer <= next_timer;
            end if;
        end if;
    
    end process;

end hlsm;

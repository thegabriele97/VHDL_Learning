library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsmd_controller is
    port(
        clk, rst, start: in std_logic;
        ready: out std_logic;
        
        --Control & Status signals
        ld_a, ld_b, ld_p: out std_logic;
        shl_a, shr_b: out std_logic;
        en_p: out std_logic;
        
        tc_b, b0_1: in std_logic
    );
end fsmd_controller;

architecture Behavioral of fsmd_controller is

    type fsm_state is ( idle, check, check_odd, calc, finish );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, start, tc_b, b0_1)
    begin
    
        next_state <= curr_state;
        ready <= '0';
        ld_a <= '0';
        ld_b <= '0';
        ld_p <= '0';
        en_p <= '0';
        shl_a <= '0';
        shr_b <= '0';
        
        case curr_state is
        
            when idle =>
                ld_a <= '1';
                ld_b <= '1';
                ld_p <= '1';
        
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                
                if (tc_b = '1') then
                    next_state <= finish;
                elsif (b0_1 = '1') then
                    next_state <= check_odd;
                end if;
                
            when check_odd =>
                en_p <= '1';
                next_state <= calc;
            
            when calc =>    
                shl_a <= '1';
                shr_b <= '1';
                
                next_state <= check;
                
            when finish =>
                ready <= '1';
                
                next_state <= idle;
            
            when others =>
                next_state <= idle;
        
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= idle;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end Behavioral;

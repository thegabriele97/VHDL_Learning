library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer is
    port(
        clk, rst, bi: in std_logic;
        bo: out std_logic
    );
end debouncer;

architecture fsm of debouncer is

    type fsm_state is ( wait_bi, bo_on, bo_off );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, bi)
    begin
    
        next_state <= curr_state;
        bo <= '0';
        
        case curr_state is
        
            when wait_bi =>
                if (bi = '1') then
                    next_state <= bo_on;
                end if;
                
            when bo_on =>
                bo <= '1';
                next_state <= bo_off;
                
            when bo_off =>
                if (bi = '0') then
                    next_state <= wait_bi;
                end if;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_bi;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end fsm;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity btn_sync is
    port(
        clk, rst, bi: in std_logic;
        bo: out std_logic
    );
end btn_sync;

architecture fsm of btn_sync is

    type fsm_state is ( wait_bi, bon, boff );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, bi)
    begin
    
        next_state <= curr_state;
        bo <= '0';
        
        case curr_state is
        
            when wait_bi =>
                if (bi = '1') then
                    next_state <= bon;
                end if;
                
            when bon =>
                bo <= '1';
                next_state <= boff;
                
            when boff =>
                if (bi = '0') then
                    next_state <= wait_bi;
                end if;
        
            when others =>
                next_state <= wait_bi;
        
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
        
            if (rst = '1') then
                curr_state <= wait_bi;
            else
                curr_state <= next_state;
            end if;
        
        end if;
    
    end process;

end fsm;

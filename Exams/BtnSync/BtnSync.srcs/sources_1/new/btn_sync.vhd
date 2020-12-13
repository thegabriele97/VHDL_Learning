library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity btn_sync is
    port(
        clk, rst, bi: in std_logic;
        bo: out std_logic
    );
end btn_sync;

architecture Behavioral of btn_sync is

    type fsm_state is ( wait_btn, ok, sleep );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, bi)
    begin
    
        next_state <= curr_state;
        bo <= '0';
        
        case curr_state is
        
            when wait_btn =>
                if (bi = '1') then
                    next_state <= ok;
                end if;
                
            when ok =>
                bo <= '1';
                
                if (bi = '0') then
                    next_state <= wait_btn;
                elsif (bi = '1') then
                    next_state <= sleep;
                end if;
            
            when sleep =>
                if (bi = '0') then
                    next_state <= wait_btn;
                end if;
        
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_btn;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end Behavioral;

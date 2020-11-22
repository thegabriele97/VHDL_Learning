library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity btn_sync is
    port(
        clk, rst, bi: in std_logic;
        bo: out std_logic
    );
end btn_sync;

architecture Behavioral of btn_sync is

    type fsm_state is ( init, wait_btn_on, pulse, wait_btn_off );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, bi)
    begin
        
        next_state <= curr_state;
        bo <= '0';
        
        case curr_state is
            
            when init =>
                next_state <= wait_btn_on;
            
            when wait_btn_on =>
                
                if (bi = '1') then
                    next_state <= pulse;
                end if;
                
            when pulse =>
                bo <= '1';
                
                if (bi = '1') then
                    next_state <= wait_btn_off;
                elsif (bi = '0') then
                    next_state <= wait_btn_on;
                end if;
                
            when wait_btn_off =>
                
                if (bi = '0') then
                    next_state <= wait_btn_on;
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
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end Behavioral;

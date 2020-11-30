library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller is
    port(
        clk, rst, hit, rw: in std_logic;
        wr_en, en_replptr: out std_logic
    );
end Controller;

architecture Behavioral of Controller is

    type fsm_state is ( wait_comm, check, update, replace );
    signal curr_state, next_state: fsm_state;

begin
    
    process(curr_state, rw, hit)
    begin
    
        next_state <= curr_state;
        wr_en <= '0';
        en_replptr <= '0';
        
        case curr_state is
        
            when wait_comm =>
                
                if (rw = '0') then
                    next_state <= check;
                end if;
                
            when check =>
                
                if (hit = '1') then
                    next_state <= update;
                elsif (hit = '0') then
                    next_state <= replace;
                end if;
                
            when replace =>
                en_replptr <= '1';
                next_state <= update;
                
            when update =>
                wr_en <= '1';
                next_state <= wait_comm;
                
            when others =>
                next_state <= wait_comm;
        
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_comm;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end Behavioral;

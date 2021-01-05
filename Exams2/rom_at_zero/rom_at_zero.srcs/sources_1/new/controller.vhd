library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity controller is
    port(
        clk, rst, go: in std_logic;
        addr: out std_logic_vector(2 downto 0);
        data: in std_logic_vector(3 downto 0);
        counter: out std_logic_vector(3 downto 0);
        finish: out std_logic
    );
end controller;

architecture hlsm of controller is

    type fsm_state is ( wait_go, set_addr, cmp, update, done );
    signal curr_state, next_state: fsm_state;
    
    signal curr_addr, next_addr, curr_cnt, next_cnt: std_logic_vector(3 downto 0);

begin

    counter <= curr_cnt;
    addr <= curr_addr(2 downto 0);

    process(curr_state, curr_addr, curr_cnt, go, data)
    begin
    
        next_state <= curr_state;
        next_addr <= curr_addr;
        next_cnt <= curr_cnt;
        finish <= '0';
        
        case curr_state is
        
            when wait_go =>
                next_addr <= x"8";
                next_cnt <= x"0";
                
                if (go = '1') then
                    next_state <= set_addr;
                end if;
                
            when set_addr =>
                next_addr <= std_logic_vector(unsigned(curr_addr) - 1);
                
                next_state <= cmp;
                if (curr_addr = x"0") then
                    next_state <= done;
                end if;
        
            when cmp =>
                next_state <= set_addr;
                if (data = x"0") then
                    next_state <= update;
                end if;
            
            when update =>
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                next_state <= set_addr;
            
            when done =>
                finish <= '1';
                next_state <= wait_go;
                
            when others =>
                next_state <= wait_go;
        
        end case;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then 
                curr_state <= wait_go;
                curr_addr <= x"8";
                curr_cnt <= x"0";
            else
                curr_state <= next_state;
                curr_addr <= next_addr;
                curr_cnt <= next_cnt;
            end if;
        end if;
    
    end process;

end hlsm;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Controller is
    port(
        clk, rst, go: in std_logic;
        data: in std_logic_vector(3 downto 0);
        addr: out std_logic_vector(2 downto 0);
        counter: out std_logic_vector(3 downto 0);
        finish: out std_logic
    );
end Controller;

architecture hlsm of Controller is

    type fsm_state is ( wait_go, done, work, inc );
    signal curr_state, next_state: fsm_state;
    signal curr_addr, next_addr: std_logic_vector(3 downto 0);
    signal curr_data, next_data: std_logic_vector(3 downto 0);
    signal curr_cnt, next_cnt: std_logic_vector(3 downto 0);

begin

    counter <= curr_cnt;
    addr <= curr_addr(2 downto 0);
    
    process(curr_state, curr_cnt, curr_data, curr_addr, go, data)
    begin
    
        next_state <= curr_state;
        next_cnt <= curr_cnt;
        next_data <= curr_data;
        next_addr <= curr_addr;
        finish <= '0';
        
        case curr_state is
        
            when wait_go =>
                next_data <= (others => '1');
                next_cnt <= (others => '0');
                next_addr <= (others => '0');
        
                if (go = '1') then
                    next_state <= work;
                end if;
                
            when done =>
                finish <= '1';
                next_state <= wait_go;
                
            when work =>
                next_addr <= std_logic_vector(unsigned(curr_addr) + 1);
                next_data <= data;
                
                if (curr_data = x"0" and unsigned(curr_addr) < 9) then
                    next_state <= inc;
                elsif (curr_addr = x"9") then
                    next_state <= done;
                end if;
                
            when inc =>
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                next_state <= work;
                
            when others =>
                next_state <= wait_go;
        
        end case;
    
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_go;
                curr_cnt <= (others => '0');
                curr_addr <= (others => '0');
                curr_data <= (others => '0');            
            else
                curr_state <= next_state;
                curr_cnt <= next_cnt;
                curr_addr <= next_addr;
                curr_data <= next_data; 
            end if;
        end if;
    
    end process;
    
end hlsm;

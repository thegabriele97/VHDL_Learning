library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Controller is
    port(
        clk, rst, go: in std_logic;
        data: in std_logic_vector(3 downto 0);
        finish: out std_logic;
        cnt: out std_logic_vector(3 downto 0);
        addr: out std_logic_vector(2 downto 0)
    );
end Controller;

architecture fsm of Controller is

    type fsm_state is ( wait_go, put_addr, get, check, inc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_addr, next_addr: std_logic_vector(3 downto 0);
    signal curr_cnt, next_cnt: std_logic_vector(3 downto 0);
    signal curr_data, next_data: std_logic_vector(3 downto 0);

begin

    process(curr_state, curr_addr, curr_cnt, data, go)
    begin
    
        next_state <= curr_state;
        next_addr <= curr_addr;
        next_cnt <= curr_cnt;
        finish <= '0';
        
        case curr_state is
            when wait_go =>
                next_addr <= (others => '1');
                next_cnt <= (others => '0');
                
                if (go = '1') then
                    next_state <= put_addr;
                end if;
            
            when put_addr =>
                next_addr <= std_logic_vector(unsigned(curr_addr) + 1);
                
                next_state <= get;
                if (unsigned(curr_addr) = 7) then
                    next_state <= done;
                end if;
                
            when get =>
                next_data <= data;
                next_state <= check;
                
            when check =>
                next_state <= put_addr;
                if (unsigned(curr_data) = 0) then
                    next_state <= inc;
                end if;
                
            when inc =>
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                next_state <= put_addr;
                
            when done =>
                finish <= '1';
                next_state <= wait_go;
    
            when others =>
                next_state <= wait_go;
        end case;
    
    end process;
    
    cnt <= curr_cnt;
    addr <= curr_addr(2 downto 0);
    
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

end fsm;

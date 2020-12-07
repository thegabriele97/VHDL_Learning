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

architecture Behavioral of Controller is

    --Datapath signals
    signal curr_addr, next_addr: std_logic_vector(2 downto 0);
    signal curr_cnt, next_cnt: std_logic_vector(3 downto 0);

    --Controller signals
    type fsm_state is ( wait_go, check, cnt_up, end_check );
    signal curr_state, next_state: fsm_state;

    --Common signals
    signal ld_addr, en_cnt, ld_cnt, end_cnt, eq_0: std_logic;
    
begin

    cnt <= curr_cnt;
    addr <= curr_addr;
    eq_0 <= '1' when (unsigned(data) = 0) else '0';

    --Datapath
    process(curr_addr, curr_cnt, ld_addr, en_cnt, ld_cnt)
    begin
    
        --Address register
        next_addr <= curr_addr;
        if (ld_addr = '1') then
            next_addr <= std_logic_vector(unsigned(curr_addr) - 1);
        end if;
        
        end_cnt <= '0';
        if (unsigned(curr_addr) = 0) then
            end_cnt <= '1';
        end if;
        
        --Counter register
        next_cnt <= curr_cnt;
        if (ld_cnt = '1') then
            next_cnt <= (others => '0');
        elsif (en_cnt = '1') then
            next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
        end if;
    
    end process;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_addr <= (others => '1');
                curr_cnt <= (others => '0');
            else
                curr_addr <= next_addr;
                curr_cnt <= next_cnt;
            end if;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, go, end_cnt, eq_0)
    begin
    
        next_state <= curr_state;
        finish <= '0';
        ld_addr <= '0';
        en_cnt <= '0';
        ld_cnt <= '0';
        
        case curr_state is
        
            when wait_go =>
                ld_cnt <= '1';
                
                if (go = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                ld_addr <= '1';
                
                if (end_cnt = '1') then
                    next_state <= end_check;
                elsif (eq_0 = '1') then
                    next_state <= cnt_up;
                end if;
                
            when cnt_up =>
                en_cnt <= '1';
                next_state <= check;
                
            when end_check =>
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
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;
    

end Behavioral;

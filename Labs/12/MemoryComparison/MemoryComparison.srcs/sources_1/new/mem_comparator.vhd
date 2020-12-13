library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mem_comparator is
    port(
        clk, rst, go: in std_logic;
        DataIn: in std_logic_vector(3 downto 0);
        finish: out std_logic;
        cnt: out std_logic_vector(3 downto 0);
        
        addr: out std_logic_vector(2 downto 0);
        data: in std_logic_vector(3 downto 0)
    );
end mem_comparator;

architecture Behavioral of mem_comparator is

    --Datapath signals
    signal curr_addr, next_addr: std_logic_vector(2 downto 0);
    signal curr_cnt, next_cnt, curr_data, next_data: std_logic_vector(3 downto 0);

    --Controller signals
    type fsm_state is ( wait_go, next_a, cnt_up, done, loop_in );
    signal curr_state, next_state: fsm_state;

    --Control signals
    signal ld_addr, ld_data, cnt_end, data_eq: std_logic;
    signal mux_cnt: std_logic_vector(1 downto 0);

begin

    --Datapath
    cnt <= curr_cnt;
    addr <= curr_addr;
    
    process(curr_addr, curr_cnt, curr_data, DataIn, ld_addr, ld_data, mux_cnt, data)
    begin
    
        --Addr register
        next_addr <= curr_addr;
        if (ld_addr = '1') then
            next_addr <= std_logic_vector(unsigned(curr_addr) - 1);
        end if;
        
        --Data register
        next_data <= curr_data;
        if (ld_data = '1') then
            next_data <= DataIn;
        end if;
        
        --Count register
        next_cnt <= curr_cnt;
        if (mux_cnt = "01") then
            next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
        elsif (mux_cnt = "10") then
            next_cnt <= (others => '0');
        end if;
        
        --End count logic
        cnt_end <= '0';
        if (unsigned(curr_addr) = 0) then
            cnt_end <= '1';
        end if;
        
        --Data equal logic
        data_eq <= '0';
        if (unsigned(data) < unsigned(curr_data)) then
            data_eq <= '1';
        end if;
    
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_addr <= (others => '1');
                curr_cnt <= (others => '0');
                curr_data <= (others => '0');
            else
                curr_addr <= next_addr;
                curr_cnt <= next_cnt;
                curr_data <= next_data;
            end if;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, go, cnt_end, data_eq)
    begin
    
        next_state <= curr_state;
        ld_addr <= '0';
        ld_data <= '0';
        mux_cnt <= "00";
        finish <= '0';
        
        case curr_state is
        
            when wait_go =>
                ld_data <= '1';
                mux_cnt <= "10";
                
                if (go = '1') then
                    next_state <= loop_in;
                end if;
                
            when loop_in =>
                ld_addr <= '1';
                
                if (cnt_end = '0') then
                    next_state <= next_a;
                elsif (cnt_end = '1') then
                    next_state <= done;
                end if;
                
            when next_a =>
                            
                if (data_eq = '1') then
                    next_state <= cnt_up;
                elsif (data_eq = '0') then
                    next_state <= loop_in;
                end if; 
                
            when cnt_up =>
                mux_cnt <= "01";
                next_state <= loop_in;
                
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
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end Behavioral;

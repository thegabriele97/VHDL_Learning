library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pell is
    port(
        clk, rst, start: in std_logic;
        n: in std_logic_vector(2 downto 0);
        p: out std_logic_vector(7 downto 0);
        ready: out std_logic
    );
end pell;

architecture hlsm of pell is

    type fsm_state is ( wait_start, setup, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(7 downto 0);
    signal curr_n, next_n, curr_iter, next_iter: std_logic_vector(2 downto 0);

begin

    p <= curr_r1;

    process(curr_state, curr_r0, curr_r1, curr_n, curr_iter, start, n)
    begin
    
        next_state <= curr_state;
        next_r0 <= curr_r0;
        next_r1 <= curr_r1;
        next_iter <= curr_iter;
        next_n <= curr_n;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_n <= n;
                
                if (start = '1') then
                    next_state <= setup;
                end if;
        
            when setup =>
                next_iter <= "010";
                next_r0 <= (others => '0');
                next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
                next_state <= calc;
                
            when calc =>
                next_r0 <= curr_r1;
                next_r1 <= std_logic_vector(unsigned(curr_r1(6 downto 0) & '0') + unsigned(curr_r0));
                next_iter <= std_logic_vector(unsigned(curr_iter) + 1);
                
                if (unsigned(curr_iter) >= unsigned(curr_n)) then
                    next_state <= done;
                end if;
            
            when done =>
                ready <= '1';
                next_state <= wait_start;
            
            when others =>
                next_state <= wait_start;
            
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
            curr_r0 <= (others => '0');
            curr_r0 <= (others => '0');
            curr_n <= (others => '0');
            curr_iter <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
            curr_n <= next_n;
            curr_iter <= next_iter;
        end if;
    
    end process;

end hlsm;

architecture fsmd of pell is

    --Datapath signals
    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(7 downto 0);
    signal curr_n, next_n, curr_iter, next_iter: std_logic_vector(2 downto 0);

    --Controller signals
    type fsm_state is ( wait_start, setup, calc, done );
    signal curr_state, next_state: fsm_state;

    --Control signals
    signal ld_n, cnt_end: std_logic;
    signal mux_iter, mux_r0, mux_r1: std_logic_vector(1 downto 0);

begin
    
    --Datapath
    p <= curr_r1;
    
    process(curr_r0, curr_r1, curr_n, curr_iter, ld_n, mux_iter, mux_r0, mux_r1, n)
    begin
    
        --N register
        next_n <= curr_n;
        if (ld_n = '1') then
            next_n <= n;
        end if;
        
        --Iter register
        next_iter <= curr_iter;
        if (mux_iter = "01") then
            next_iter <= std_logic_vector(unsigned(curr_iter) + 1);
        elsif (mux_iter = "10") then
            next_iter <= "010";
        end if;
        
        --End logic
        cnt_end <= '0';
        if (unsigned(curr_iter) >= unsigned(curr_n)) then
            cnt_end <= '1';
        end if;        
        
        --R0 register
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= curr_r1;
        elsif (mux_r0 = "10") then
            next_r0 <= (others => '0');
        end if;
        
        --R1 register
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= std_logic_vector(unsigned(curr_r1(6 downto 0) & '0') + unsigned(curr_r0));
        elsif (mux_r1 = "10") then
            next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
        end if;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, cnt_end, start)
    begin
    
        next_state <= curr_state;
        ld_n <= '0';
        mux_iter <= "00";
        mux_r0 <= "00";
        mux_r1 <= "00";
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                ld_n <= '1';
                
                if (start = '1') then
                    next_state <= setup;
                end if;
                
            when setup =>
                mux_iter <= "10";
                mux_iter <= "10";
                mux_r0 <= "10";
                mux_r1 <= "10";
                next_state <= calc;
            
            when calc =>
                mux_r0 <= "01";
                mux_r1 <= "01";
                mux_iter <= "01";
        
                if (cnt_end = '1') then
                    next_state <= done;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
            
            when others =>
                next_state <= wait_start;
        
        end case;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_r0 <= (others => '0');
            curr_r0 <= (others => '0');
            curr_n <= (others => '0');
            curr_iter <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
            curr_n <= next_n;
            curr_iter <= next_iter;
        end if;
    
    end process;
    

end fsmd;

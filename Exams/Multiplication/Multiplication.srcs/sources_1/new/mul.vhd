library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mul is
    port(
        clk, rst, start: in std_logic;
        a, b: in std_logic_vector(7 downto 0);
        ready: out std_logic;
        z: out std_logic_vector(15 downto 0)
    );
end mul;

architecture hlsm of mul is

    type fsm_state is ( wait_start, setup, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_a, next_a, curr_b, next_b, curr_iter, next_iter: std_logic_vector(7 downto 0);
    signal curr_sum, next_sum: std_logic_vector(15 downto 0);

begin

    z <= curr_sum;

    process(curr_state, curr_a, curr_b, curr_iter, curr_sum, start, a, b)
    begin
    
        next_state <= curr_state;
        next_a <= curr_a;
        next_b <= curr_b;
        next_iter <= curr_iter;
        next_sum <= curr_sum;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_a <= a;
                next_b <= b;
                
                if (start = '1') then
                    next_state <= setup;
                end if;
                
            when setup =>
                next_sum <= (others => '0');
                next_iter <= std_logic_vector(unsigned(curr_b) - 1);
                next_state <= calc;
                
            when calc =>
                next_sum <= std_logic_vector(unsigned(curr_sum) + unsigned(curr_a));
                next_iter <= std_logic_vector(unsigned(curr_iter) - 1);
                
                if (unsigned(curr_iter) = 0) then
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
            curr_a <= (others => '0');
            curr_b <= (others => '0');
            curr_sum <= (others => '0');
            curr_iter <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_a <= next_a;
            curr_b <= next_b;
            curr_sum <= next_sum;
            curr_iter <= next_iter;
        end if;
    
    end process;

end hlsm;

architecture fsmd of mul is

    --Datapath signals
    signal curr_a, next_a, curr_b, next_b, curr_iter, next_iter: std_logic_vector(7 downto 0);
    signal curr_sum, next_sum: std_logic_vector(15 downto 0);
    
    --Controller signals
    type fsm_state is ( wait_start, setup, calc, done );
    signal curr_state, next_state: fsm_state;

    --Control signals
    signal ld_a, ld_b, cnt_end: std_logic;
    signal mux_sum, mux_iter: std_logic_vector(1 downto 0);

begin
    
    --Datapath
    z <= curr_sum;
    
    process(curr_a, curr_b, curr_iter, curr_sum, ld_a, ld_b, mux_sum, mux_iter, a, b)
    begin
    
        --A register
        next_a <= curr_a;
        if (ld_a = '1') then
            next_a <= a;
        end if;
    
        --B register
        next_b <= curr_b;
        if (ld_b = '1') then
            next_b <= b;
        end if;
        
        --Sum register
        next_sum <= curr_sum;
        if (mux_sum = "01") then
            next_sum <= std_logic_vector(unsigned(curr_sum) + unsigned(curr_a));
        elsif (mux_sum = "10") then
            next_sum <= (others => '0');
        end if;
        
        --Iter register
        next_iter <= curr_iter;
        if (mux_iter = "01") then
            next_iter <= std_logic_vector(unsigned(curr_iter) - 1);
        elsif (mux_iter = "10") then
            next_iter <= std_logic_vector(unsigned(curr_b) - 1);
        end if;
        
        --Count end logic
        cnt_end <= '0';
        if (unsigned(curr_iter) = 0) then
            cnt_end <= '1';
        end if;

    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_a <= (others => '0');
            curr_b <= (others => '0');
            curr_sum <= (others => '0');
            curr_iter <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_a <= next_a;
            curr_b <= next_b;
            curr_sum <= next_sum;
            curr_iter <= next_iter;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, start, cnt_end)
    begin
    
        next_state <= curr_state;
        ld_a <= '0';
        ld_b <= '0';
        mux_sum <= "00";
        mux_iter <= "00";
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                ld_a <= '1';
                ld_b <= '1';
                
                if (start = '1') then
                    next_state <= setup;
                end if;
                
            when setup =>
                mux_sum <= "10";
                mux_iter <= "10";
                next_state <= calc;
                
            when calc =>
                mux_sum <= "01";
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
            curr_state <= wait_start;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end fsmd;

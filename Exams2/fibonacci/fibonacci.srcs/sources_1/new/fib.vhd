library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fib is
    port(
        clk, rst, start: in std_logic;
        n: in std_logic_vector(3 downto 0);
        ready: out std_logic;
        data_out: out std_logic_vector(9 downto 0)
    );
end fib;

architecture hlsm of fib is

    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    
    signal curr_r1, next_r1, curr_r2, next_r2: std_logic_vector(9 downto 0);
    signal curr_n, next_n: std_logic_vector(3 downto 0);

begin

    data_out <= curr_r2;

    process(curr_state, curr_r1, curr_r2, curr_n, n, start)
    begin
    
        next_state <= curr_state;
        next_r1 <= curr_r1;
        next_r2 <= curr_r2;
        next_n <= curr_n;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_n <= n;
                next_r1 <= (others => '0');
                next_r2 <= std_logic_vector(TO_UNSIGNED(1, next_r2'length));
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (unsigned(curr_n) = 1) then
                    next_state <= done;
                end if;
            
            when calc =>
                next_r2 <= std_logic_vector(unsigned(curr_r2) + unsigned(curr_r1));
                next_r1 <= curr_r2;
                next_n <= std_logic_vector(unsigned(curr_n) - 1);
                next_state <= check;
                
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
            curr_r1 <= (others => '0');
            curr_r2 <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_r1 <= next_r1;
            curr_r2 <= next_r2;
            curr_n <= next_n;
        end if;
    
    end process;

end hlsm;

architecture fsmd of fib is

    -- Datapath signals
    signal curr_r1, next_r1, curr_r2, next_r2: std_logic_vector(9 downto 0);
    signal curr_n, next_n: std_logic_vector(3 downto 0);
    
    -- Controller signals
    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;    
    
    -- Control signals
    signal mux_r1, mux_r2, mux_n: std_logic_vector(1 downto 0);
    signal echone: std_logic;

begin

    data_out <= curr_r2;
    
    -- Datapath description
    process(curr_r1, curr_r2, curr_n, mux_r1, mux_r2, mux_n, n)
    begin
    
        -- R1 register
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= curr_r2;
        elsif (mux_r1 = "10") then
            next_r1 <= (others => '0');
        end if;
        
        -- R2 register
        next_r2 <= curr_r2;
        if (mux_r2 = "01") then
            next_r2 <= std_logic_vector(unsigned(curr_r1) + unsigned(curr_r2));
        elsif (mux_r2 = "10") then
            next_r2 <= std_logic_vector(TO_UNSIGNED(1, next_r2'length));
        end if;
        
        -- N register
        next_n <= curr_n;
        if (mux_n = "01") then
            next_n <= std_logic_vector(unsigned(curr_n) - 1);
        elsif (mux_n = "10") then
            next_n <= n;
        end if;
        
        -- Echone logic
        echone <= '0';
        if (unsigned(curr_n) = 1) then
            echone <= '1';
        end if;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_r1 <= (others => '0');
            curr_r2 <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_r1 <= next_r1;
            curr_r2 <= next_r2;
            curr_n <= next_n;
        end if;
    
    end process;
    
    -- Controller description
    process(curr_state, echone, start)
    begin
    
        next_state <= curr_state;
        mux_r1 <= "00";
        mux_r2 <= "00";
        mux_n <= "00";
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                mux_r1 <= "10";
                mux_r2 <= "10";
                mux_n <= "10";
                
                if (start = '1') then
                    next_state <= check;
                end if;
            
            when check =>
                next_state <= calc;
                if (echone = '1') then
                    next_state <= done;
                end if;
                
            when calc =>
                mux_r1 <= "01";
                mux_r2 <= "01";
                mux_n <= "01";
                next_state <= check;
            
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

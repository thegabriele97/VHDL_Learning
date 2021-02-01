library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity binomial is
    port(
        clk, rst, start: in std_logic;
        n, k: in std_logic_vector(2 downto 0);
        ready: out std_logic;
        data_out: out std_logic_vector(12 downto 0)
    );
end binomial;

architecture hlsm of binomial is

    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_n, next_n: std_logic_vector(2 downto 0);
    signal curr_k, next_k: std_logic_vector(2 downto 0);
    signal curr_r0, next_r0: std_logic_vector(12 downto 0);
    signal curr_r1, next_r1: std_logic_vector(9 downto 0);
    signal curr_r2, next_r2: std_logic_vector(12 downto 0);

begin

    process(curr_state, curr_n, curr_k, curr_r0, curr_r1, curr_r2, n, k, start)
    begin
    
        next_state <= curr_state;
        next_n <= curr_n;
        next_k <= curr_k;
        ready <= '0';
        next_r0 <= curr_r0;
        next_r1 <= curr_r1;
        next_r2 <= curr_r2;
        
        case curr_state is
        
            when wait_Start =>
                next_n <= n;
                next_k <= k;
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
                
            when check =>
                next_state <= calc;
                next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
                next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
                next_r2 <= std_logic_vector(TO_UNSIGNED(1, next_r2'length));
        
                if (unsigned(curr_n) <= unsigned(curr_k) or unsigned(k) < 1) then
                    next_state <= done;
                end if; 
        
            when calc =>
                next_r0 <= std_logic_vector(unsigned(curr_n) * unsigned(curr_r0(9 downto 0)));
                next_r1 <= std_logic_vector(unsigned(curr_k) * unsigned(curr_r1(6 downto 0)));
                next_r2 <= std_logic_vector(unsigned(curr_r0) / unsigned(curr_r1));
                next_n <= std_logic_vector(unsigned(curr_n) - 1);
                next_k <= std_logic_vector(unsigned(curr_k) - 1);
        
                if (unsigned(curr_k) = 0) then
                    next_state <= done;
                end if;
                
            when others =>
                next_state <= wait_start;
        
        end case;
    
    end process;
    
    data_out <= curr_r2;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
            curr_n <= (others => '0');
            curr_k <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
            curr_r2 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_n <= next_n;
            curr_k <= next_k;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
            curr_r2 <= next_r2;
        end if;
    
    end process;

end hlsm;

architecture fsmd of binomial is
    
    -- Datapath signals
    signal curr_n, next_n: std_logic_vector(2 downto 0);
    signal curr_k, next_k: std_logic_vector(2 downto 0);
    signal curr_r0, next_r0: std_logic_vector(12 downto 0);
    signal curr_r1, next_r1: std_logic_vector(9 downto 0);
    signal curr_r2, next_r2: std_logic_vector(12 downto 0);    
    
    -- Controller signals
    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    
    -- Control signals
    signal mux_n, mux_k, mux_r0, mux_r1, mux_r2: std_logic_vector(1 downto 0);
    signal lt, eq_0: std_logic;

begin

    process(curr_state, start, lt, eq_0)
    begin
    
        next_state <= curr_state;
        mux_n <= "00";
        mux_k <= "00";
        mux_r0 <= "00";
        mux_r1 <= "00";
        mux_r2 <= "00";
        ready <= '0';
        
        case curr_state is
        
            when wait_Start =>
                mux_n <= "10";
                mux_k <= "10";
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
                
            when check =>
                mux_r0 <= "10";
                mux_r1 <= "10";
                mux_r2 <= "10";
            
                next_state <= calc;
                if (lt = '1' or eq_0 = '1') then
                    next_state <= done;
                end if; 
        
            when calc =>
                mux_r0 <= "01";
                mux_r1 <= "01";
                mux_r2 <= "01";
                mux_n <= "01";
                mux_k <= "01";
        
                if (eq_0 = '1') then
                    next_state <= done;
                end if;
                
            when others =>
                next_state <= wait_start;
        
        end case;
    
    end process;

    process(curr_n, curr_k, curr_r0, curr_r1, curr_r2, mux_n, mux_k, mux_r0, mux_r1, mux_r2, n, k)
    begin
    
        next_n <= curr_n;
        if (mux_n = "01") then
            next_n <= std_logic_vector(unsigned(curr_n) - 1);
        elsif (mux_n = "10") then
            next_n <= n;
        end if;
        
        next_k <= curr_k;
        if (mux_k = "01") then
            next_k <= std_logic_vector(unsigned(curr_k) - 1);
        elsif (mux_k = "10") then
            next_k <= k;
        end if;

        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= std_logic_vector(unsigned(curr_n) * unsigned(curr_r0(9 downto 0)));
        elsif (mux_r0 = "10") then
            next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
        end if;
        
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= std_logic_vector(unsigned(curr_k) * unsigned(curr_r1(6 downto 0)));
        elsif (mux_r1 = "10") then
            next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
        end if;        
    
        next_r2 <= curr_r2;
        if (mux_r2 = "01") then
            if (unsigned(curr_r1) /= 0) then
                next_r2 <= std_logic_vector(unsigned(curr_r0) / unsigned(curr_r1));
            end if;
        elsif (mux_r2 = "10") then
            next_r2 <= std_logic_vector(TO_UNSIGNED(1, next_r2'length));
        end if;
        
        lt <= '0';
        if (unsigned(curr_n) <= unsigned(curr_k)) then
            lt <= '1';
        end if;
    
        eq_0 <= '0';
        if (unsigned(curr_k) = 0) then
            eq_0 <= '1';
        end if;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_n <= (others => '0');
            curr_k <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
            curr_r2 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_n <= next_n;
            curr_k <= next_k;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
            curr_r2 <= next_r2;
        end if;
    
    end process;
    
    data_out <= curr_r2;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end fsmd;
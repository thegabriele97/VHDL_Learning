library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity factorial is
    port(
        clk, rst, start: in std_logic;
        n: in std_logic_vector(2 downto 0);
        ready: out std_logic;
        data_out: out std_logic_vector(12 downto 0)
    );
end factorial;

architecture hlsm of factorial is

    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_n, next_n: std_logic_vector(2 downto 0);
    signal curr_r0, next_r0: std_logic_vector(12 downto 0);
    signal curr_iter, next_iter: std_logic_vector(2 downto 0);

begin

    process(curr_state, curr_n, curr_r0, curr_iter, n, start)
    begin
    
        next_state <= curr_state;
        next_n <= curr_n;
        next_R0 <= curr_r0;
        next_iter <= curr_iter;
        ready <= '0';
    
        case curr_state is
        
            when wait_start =>
                next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
                next_n <= std_logic_vector(TO_UNSIGNED(2, next_n'length));
                next_iter <= n;
                
                if (start = '1') then
                    next_state <= check;
                end if;
        
            when check =>
                next_state <= calc;
                if (unsigned(curr_n) > unsigned(curr_iter)) then
                    next_state <= done;
                end if;
                
            when done => 
                ready <= '1';
                next_state <= wait_start;
        
            when calc =>
                next_r0 <= std_logic_vector(unsigned(curr_n) * unsigned(curr_r0(9 downto 0)));
                next_n <= std_logic_vector(unsigned(curr_n) + 1);
                
                if (unsigned(curr_n) = unsigned(curr_iter)) then
                    next_state <= done;
                end if;
                
            when others =>
                next_state <= wait_start;
        
        end case;
        
    end process;

    data_out <= curr_r0;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then 
            curr_state <= wait_start;
            curr_r0 <= (others => '0');
            curr_iter <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_r0 <= next_r0;
            curr_iter <= next_iter;
            curr_n <= next_n;
        end if;
    
    end process;

end hlsm;

architecture fsmd of factorial is

    -- Datapath signals
    signal curr_n, next_n: std_logic_vector(2 downto 0);
    signal curr_r0, next_r0: std_logic_vector(12 downto 0);
    signal curr_iter, next_iter: std_logic_vector(2 downto 0);
    
    -- Controller signals
    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;

    -- Control signals
    signal mux_n, mux_r0: std_logic_vector(1 downto 0);
    signal ld_iter, gt, eq: std_logic;

begin

    process(curr_r0, curr_n, curr_iter, n, mux_n, mux_r0, ld_iter)
    begin
    
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= std_logic_vector(unsigned(curr_n) * unsigned(curr_r0(9 downto 0)));
        elsif (mux_r0 = "10") then
            next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
        end if;
        
        next_n <= curr_n;
        if (mux_n = "01") then
            next_n <= std_logic_vector(unsigned(curr_n) + 1);
        elsif (mux_n = "10") then
            next_n <= std_logic_vector(TO_UNSIGNED(2, next_n'length));
        end if;
    
        next_iter <= curr_iter;
        if (ld_iter = '1') then
            next_iter <= n;
        end if;
    
        gt <= '0';
        if (unsigned(curr_n) > unsigned(curr_iter)) then
            gt <= '1';
        end if;
        
        eq <= '0';
        if (unsigned(curr_n) = unsigned(curr_iter)) then
            eq <= '1';
        end if;
    
    end process;

    data_out <= curr_r0;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_r0 <= (others => '0');
            curr_iter <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_r0 <= next_r0;
            curr_iter <= next_iter;
            curr_n <= next_n;
        end if;
    
    end process;
    
    process(curr_state, start, gt, eq)
    begin
    
        next_state <= curr_state;
        mux_r0 <= "00";
        ready <= '0';
        ld_iter <= '0';
        mux_n <= "00";
    
        case curr_state is
        
            when wait_start =>
                mux_r0 <= "10";
                mux_n <= "10";
                ld_iter <= '1';
                
                if (start = '1') then
                    next_state <= check;
                end if;
        
            when check =>
                next_state <= calc;
                if (gt = '1') then
                    next_state <= done;
                end if;
                
            when done => 
                ready <= '1';
                next_state <= wait_start;
        
            when calc =>
                mux_r0 <= "01";
                mux_n <= "01";
                
                if (eq = '1') then
                    next_state <= done;
                end if;
                
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

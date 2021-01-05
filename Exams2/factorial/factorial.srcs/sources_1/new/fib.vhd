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

    signal curr_r0, next_r0: std_logic_vector(12 downto 0);
    signal curr_r1, next_r1: std_logic_vector(3 downto 0);
    signal curr_n, next_n: std_logic_vector(2 downto 0);

begin

    data_out <= curr_r0;

    process(curr_state, curr_r0, curr_r1, curr_n, start, n)
    begin
    
        next_state <= curr_state;
        next_r0 <= curr_r0;
        next_r1 <= curr_r1;
        next_n <= curr_n;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
                next_r1 <= x"1";
                next_n <= n;
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (unsigned(curr_r1) > unsigned(curr_n)) then
                    next_state <= done;
                end if;
                
            when calc =>
                next_r0 <= std_logic_vector(unsigned(curr_r0(9 downto 0)) * unsigned(curr_r1(2 downto 0)));
                next_r1 <= std_logic_vector(unsigned(curr_r1) + 1);
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
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
            curr_n <= next_n;
        end if;
    
    end process;

end hlsm;

architecture fsmd of factorial is

    -- Datapath signals
    signal curr_r0, next_r0: std_logic_vector(12 downto 0);
    signal curr_r1, next_r1: std_logic_vector(3 downto 0);
    signal curr_n, next_n: std_logic_vector(2 downto 0);

    -- Controller signals
    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;

    -- Control signals
    signal mux_r0, mux_r1: std_logic_vector(1 downto 0);
    signal ld_n, stop: std_logic;

begin

    data_out <= curr_r0;

    -- Datapath description
    process(curr_r0, curr_r1, curr_n, mux_r0, mux_r1, ld_n, n)
    begin
    
        -- R0 register
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= std_logic_vector(unsigned(curr_r0(9 downto 0)) * unsigned(curr_r1(2 downto 0)));
        elsif (mux_r0 = "10") then
            next_r0 <= std_logic_vector(TO_UNSIGNED(1, next_r0'length));
        end if;
        
        -- R1 register
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= std_logic_vector(unsigned(curr_r1) + 1);
        elsif (mux_r1 = "10") then
            next_r1 <= x"1";
        end if;        
        
        -- N register
        next_n <= curr_n;
        if (ld_n = '1') then
            next_n <= n;
        end if;
        
        -- Stop logic
        stop <= '0';
        if (unsigned(curr_r1) > unsigned(curr_n)) then
            stop <= '1';
        end if;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
            curr_n <= next_n;
        end if;
    
    end process;
    
    -- Controller description
    process(curr_state, start, stop)
    begin
    
        next_state <= curr_state;
        mux_r0 <= "00";
        mux_r1 <= "00";
        ld_n <= '0';
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                mux_r0 <= "10";
                mux_r1 <= "10";
                ld_n <= '1';
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (stop = '1') then
                    next_state <= done;
                end if;
                
            when calc =>
                mux_r0 <= "01";
                mux_r1 <= "01";
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

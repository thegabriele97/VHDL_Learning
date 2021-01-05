library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pell is
    port(
        clk, rst, start: in std_logic;
        n: in std_logic_vector(2 downto 0);
        ready: out std_logic;
        p: out std_logic_vector(7 downto 0)
    );
end pell;

architecture hlsm of pell is

    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;

    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(7 downto 0);
    signal curr_n, next_n: std_logic_vector(2 downto 0);

begin
    
    p <= curr_r1;

    process(curr_state, curr_r0, curr_r1, curr_n, n, start)
    begin
    
        next_state <= curr_state;
        next_r0 <= curr_r0;
        next_r1 <= curr_r1;
        next_n <= curr_n;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_r0 <= x"00";
                next_r1 <= x"01";
                next_n <= n;
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (curr_n = "001") then
                    next_state <= done;
                end if;
                
            when calc =>
                next_r0 <= curr_r1;
                next_r1 <= std_logic_vector(unsigned(curr_r1(6 downto 0) & '0') + unsigned(curr_r0));
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

architecture fsmd of pell is

    -- Datapath signals
    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(7 downto 0);
    signal curr_n, next_n: std_logic_vector(2 downto 0);
    
    -- Controller signals
    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    
    -- Control signals
    signal mux_r0, mux_r1, mux_n: std_logic_vector(1 downto 0);
    signal stop: std_logic;    

begin

    p <= curr_r1;

    -- Datapath description
    process(curr_r0, curr_r1, curr_n, mux_r0, mux_r1, mux_n, n)
    begin
    
        -- R0 register
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= curr_r1;
        elsif (mux_r0 = "10") then
            next_r0 <= x"00";
        end if;
    
        -- R1 register
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= std_logic_vector(unsigned(curr_r1(6 downto 0) & '0') + unsigned(curr_r0));
        elsif (mux_r1 = "10") then
            next_r1 <= x"01";
        end if;
        
        -- N register
        next_n <= curr_n;
        if (mux_n = "01") then
            next_n <= std_logic_vector(unsigned(curr_n) - 1);
        elsif (mux_n = "10") then
            next_n <= n;
        end if;        
        
        -- Stop logic
        stop <= '0';
        if (curr_n = "001") then
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
        mux_n <= "00";
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                mux_r0 <= "10";
                mux_r1 <= "10";
                mux_n <= "10";
                
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

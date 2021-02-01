library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pell is
    port(
        clk, rst, start: in std_logic;
        n: in std_logic_vector(2 downto 0);
        ready: out std_logic;
        P: out std_logic_vector(7 downto 0) 
    );
end entity;

architecture hlsm of pell is

    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_r0, curr_r1, next_r0, next_r1: std_logic_vector(7 downto 0);
    signal curr_n, next_n: std_logic_vector(2 downto 0);

begin

    process(curr_state, curr_r0, curr_r1, curr_n, n, start)
    begin
    
        next_state <= curr_state;
        next_r0 <= curr_r0;
        next_r1 <= curr_r1;
        next_n <= curr_n;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_r0 <= (others => '0');
                next_r1 <= x"01";
                next_n <= n;
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
        
            when check =>
                next_state <= calc;
                if (curr_n = "000") then
                    next_state <= done;
                end if;
                
            when calc =>
                next_r0 <= curr_r1;
                next_r1 <= std_logic_vector(unsigned(curr_r1(6 downto 0) & '0') + unsigned(curr_r0));
                next_n <= std_logic_vector(unsigned(curr_n) - 1);
                
                if (unsigned(curr_n) <= 1) then
                    next_state <= done;
                end if;
                
            when others =>
                next_state <= wait_start;
            
        end case;
    
    end process;

    P <= curr_r0;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_n <= next_n;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;

end hlsm;

architecture fsmd of pell is

    -- Datapath signals
    signal curr_r0, curr_r1, next_r0, next_r1: std_logic_vector(7 downto 0);
    signal curr_n, next_n: std_logic_vector(2 downto 0);

    -- Controller signals
    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;

    -- Control signals
    signal mux_r0, mux_r1, mux_n: std_logic_vector(1 downto 0);
    signal eq_0, eq_1: std_logic;

begin

    process(curr_r0, curr_r1, curr_n, mux_r0, mux_r1, mux_n, n)
    begin
    
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= curr_r1;
        elsif (mux_r0 = "10") then
            next_r0 <= (others => '0');
        end if;
    
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= std_logic_vector(unsigned(curr_r1(6 downto 0) & '0') + unsigned(curr_r0));
        elsif (mux_r1 = "10") then
            next_r1 <= x"01";
        end if;
    
        next_n <= curr_n;
        if (mux_n = "01") then
            next_n <= std_logic_vector(unsigned(curr_n) - 1);
        elsif (mux_n = "10") then
            next_n <= n;
        end if;
    
        eq_0 <= '0';
        if (curr_n = "000") then
            eq_0 <= '1';
        end if;
        
        eq_1 <= '0';
        if (curr_n = "001") then
            eq_1 <= '1';
        end if;
    
    end process;
    
    P <= curr_r0;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_n <= next_n;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;
    
    
    
    process(curr_state, start, eq_0, eq_1)
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
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
        
            when check =>
                next_state <= calc;
                if (eq_0 = '1') then
                    next_state <= done;
                end if;
                
            when calc =>
                mux_r0 <= "01";
                mux_r1 <= "01";
                mux_n <= "01";
                
                if (eq_0 = '1' or eq_1 = '1') then
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

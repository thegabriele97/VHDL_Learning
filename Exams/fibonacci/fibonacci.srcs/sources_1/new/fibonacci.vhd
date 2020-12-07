library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fibonacci is
    port(
        clk, rst, start: in std_logic;
        n: in std_logic_vector(3 downto 0);
        ready: out std_logic;
        fib: out std_logic_vector(9 downto 0)
    );
end fibonacci;

architecture hlsm of fibonacci is

    type fsm_state is ( wait_start, prepare, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_iter, next_iter: std_logic_vector(3 downto 0);
    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(9 downto 0);

begin

    fib <= curr_r1;

    process(curr_state, curr_iter, curr_r0, curr_r1, start, n)
    begin
    
        next_state <= curr_state;
        next_iter <= curr_iter;
        next_r0 <= curr_r0;
        next_r1 <= curr_r1;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_r0 <= std_logic_vector(TO_UNSIGNED(0, next_r0'length));
                next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
                
                if (start = '1') then
                    next_state <= prepare;
                end if;
                
            when prepare =>
                next_iter <= std_logic_vector(unsigned(n) - 2);
                next_state <= calc;
                
            when calc =>
                next_r0 <= curr_r1;
                next_r1 <= std_logic_vector(unsigned(curr_r0) + unsigned(curr_r1));
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
            curr_iter <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_iter <= next_iter;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;

end hlsm;

architecture fsmd of fibonacci is

    --Datapath signals
    signal curr_iter, next_iter: std_logic_vector(3 downto 0);
    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(9 downto 0);
    
    --Controller signals
    type fsm_state is ( wait_start, prepare, calc, done );
    signal curr_state, next_state: fsm_state;
    
    --Control signals
    signal mux_iter, mux_r0, mux_r1: std_logic_vector(1 downto 0);
    signal end_iter: std_logic;

begin

    --Datapath
    end_iter <= '1' when (unsigned(curr_iter) = 0) else '0';
    fib <= curr_r1;
    
    process(curr_iter, curr_r0, curr_r1, mux_iter, mux_r0, mux_r1, n)
    begin
    
        --Iter register
        next_iter <= curr_iter;
        if (mux_iter = "01") then
            next_iter <= std_logic_vector(unsigned(curr_iter) - 1);
        elsif (mux_iter = "10") then
            next_iter <= std_logic_vector(unsigned(n) - 2);
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
            next_r1 <= std_logic_vector(unsigned(curr_r0) + unsigned(curr_r1));
        elsif (mux_r1 = "10") then
            next_r1 <= std_logic_vector(TO_UNSIGNED(1, next_r1'length));
        end if;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_iter <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_iter <= next_iter;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, start, end_iter)
    begin
    
        next_state <= curr_State;
        mux_iter <= "00";
        mux_r0 <= "00";
        mux_r1 <= "00";
        ready <= '0';
    
        case curr_state is
        
            when wait_start =>
                mux_r0 <= "10";
                mux_r1 <= "10";
                
                if (start = '1') then
                    next_state <= prepare;
                end if;
                
            when prepare =>
                mux_iter <= "10";
                next_state <= calc;
            
            when calc =>
                mux_r0 <= "01";
                mux_r1 <= "01";
                mux_iter <= "01";
                
                if (end_iter = '1') then
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

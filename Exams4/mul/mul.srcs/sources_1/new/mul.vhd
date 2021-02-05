library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mul is
    port(
        clk, rst, start: in std_logic;
        a, b: in std_logic_vector(7 downto 0);
        z: out std_logic_vector(15 downto 0);
        ready: out std_logic
    );
end mul;

architecture hlsm of mul is

    type fsm_state is ( wait_start, done, calc, check );
    signal curr_state, next_state: fsm_state;
    signal curr_a, next_a, curr_b, next_b: std_logic_vector(7 downto 0);
    signal curr_r0, next_r0: std_logic_vector(15 downto 0);

begin

    z <= curr_r0;
    
    process(curr_state, curr_a, curr_b, curr_r0, a, b, start)
    begin
    
        next_state <= curr_state;
        next_a <= curr_a;
        next_b <= curr_b;
        next_r0 <= curr_r0;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_a <= a;
                next_b <= b;
                next_r0 <= (others => '0');
        
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (curr_a = x"00" or curr_b = x"00") then
                    next_state <= done;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
                
            when calc =>
                next_r0 <= std_logic_vector(unsigned(curr_r0) + unsigned(curr_a));
                next_b <= std_logic_vector(unsigned(curr_b) - 1);
                
                if (curr_b = x"01") then
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
            curr_a <= (others => '0');
            curr_b <= (others => '0');
            curr_r0 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_a <= next_a;
            curr_b <= next_b;
            curr_r0 <= next_r0;
        end if;    
            
    end process;

end hlsm;

architecture fsmd of mul is

    type fsm_state is ( wait_start, done, calc, check );
    signal curr_state, next_state: fsm_state;

    signal curr_a, next_a, curr_b, next_b: std_logic_vector(7 downto 0);
    signal curr_r0, next_r0: std_logic_vector(15 downto 0);

    signal mux_b, mux_r0: std_logic_vector(1 downto 0);
    signal ld_a, eq_0, eq_1, a_eq_0: std_logic;

begin

    z <= curr_r0;
    
    process(curr_state, curr_a, curr_b, curr_r0, mux_b, mux_r0, ld_a, a , b)
    begin
    
        next_b <= curr_b;
        if (mux_b = "01") then
            next_b <= std_logic_vector(unsigned(curr_b) - 1);
        elsif (mux_b = "10") then
            next_b <= b;
        end if;
    
        next_a <= curr_a;
        if (ld_a = '1') then
            next_a <= a;
        end if;
        
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= std_logic_vector(unsigned(curr_r0) + unsigned(curr_a));
        elsif (mux_r0 = "10") then
            next_r0 <= (others => '0');
        end if;
        
        eq_0 <= '0';
        if (curr_b = x"00") then
            eq_0 <= '1';
        end if;
        
        a_eq_0 <= '0';
        if (curr_a = x"00") then
            a_eq_0 <= '1';
        end if;
        
        eq_1 <= '0';
        if (curr_b = x"01") then
            eq_1 <= '1';
        end if;        
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_a <= (others => '0');
            curr_b <= (others => '0');
            curr_r0 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_a <= next_a;
            curr_b <= next_b;
            curr_r0 <= next_r0;
        end if;    
            
    end process;
    
    process(curr_state, start, eq_0, eq_1, a_eq_0)
    begin
    
        next_state <= curr_state;
        mux_b <= "00";
        mux_r0 <= "00";
        ld_a <= '0';
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                mux_b <= "10";
                mux_r0 <= "10";
                ld_a <= '1';
        
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (a_eq_0 = '1' or eq_0 = '1') then
                    next_state <= done;
                end if;
                
            when done =>
                ready <= '1';
                next_state <= wait_start;
                
            when calc =>
                mux_b <= "01";
                mux_r0 <= "01";
                
                if (eq_1 = '1') then
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

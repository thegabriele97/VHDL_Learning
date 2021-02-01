library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mult is
    port(
        clk, rst, start: in std_logic;
        a, b: in std_logic_vector(7 downto 0);
        ready: out std_logic;
        z: out std_logic_vector(15 downto 0)
    );
end entity;

architecture hlsm of mult is

    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_a, curr_b, next_a, next_b: std_logic_vector(7 downto 0);
    signal curr_r0, next_r0: std_logic_vector(15 downto 0);

begin

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
            curr_r0 <= (others => '0');
            curr_a <= (others => '0');
            curr_b <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_r0 <= next_r0;
            curr_a <= next_a;
            curr_b <= next_b;
        end if;
    
    end process;
    
    process(curr_state, curr_a, curr_b, a, b, curr_r0, start)
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
        
            when done =>
                ready <= '1';
                next_state <= wait_start;
        
            when check =>
                next_state <= calc;
                if (curr_b = x"00" or curr_a = x"00") then
                    next_state <= done;
                end if;
                
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

    z <= curr_r0;
    
end hlsm;

architecture fsmd of mult is

    -- Datapath signals
    signal curr_a, curr_b, next_a, next_b: std_logic_vector(7 downto 0);
    signal curr_r0, next_r0: std_logic_vector(15 downto 0);    

    -- Controller signals
    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;

    -- Control signals
    signal mux_b, mux_r0: std_logic_vector(1 downto 0);
    signal ld_a, a_eq0, b_eq0, b_eq1: std_logic;

begin

    z <= curr_r0;

    process(curr_a, curr_b, curr_r0, a, b, mux_b, mux_r0, ld_a)
    begin
    
        next_a <= curr_a;
        if (ld_a = '1') then
            next_a <= a;
        end if;
        
        next_b <= curr_b;
        if (mux_b = "01") then
            next_b <= std_logic_vector(unsigned(curr_b) - 1);
        elsif (mux_b = "10") then
            next_b <= b;
        end if;
        
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= std_logic_vector(unsigned(curr_r0) + unsigned(curr_a));
        elsif (mux_r0 = "10") then
            next_r0 <= (others => '0');
        end if;
                 
        a_eq0 <= '0';
        if (curr_a = x"00") then
            a_eq0 <= '1';
        end if;
        
        b_eq0 <= '0';
        if (curr_b = x"00") then
            b_eq0 <= '1';
        end if;

        b_eq1 <= '0';
        if (curr_b = x"01") then
            b_eq1 <= '1';
        end if;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_r0 <= (others => '0');
            curr_a <= (others => '0');
            curr_b <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_r0 <= next_r0;
            curr_a <= next_a;
            curr_b <= next_b;
        end if;
    
    end process;
    
    process(curr_state, start, a_eq0, b_eq0, b_eq1)
    begin
    
        next_state <= curr_state;
        mux_r0 <= "00";
        mux_b <= "00";
        ld_a <= '0';
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                ld_a <= '1';
                mux_b <= "10";
                mux_r0 <= "10";
        
                if (start = '1') then
                    next_state <= check;
                end if;
        
            when done =>
                ready <= '1';
                next_state <= wait_start;
        
            when check =>
                next_state <= calc;
                if (b_eq0 = '1' or a_eq0 = '1') then
                    next_state <= done;
                end if;
                
            when calc =>
                mux_b <= "01";
                mux_r0 <= "01";
        
                if (b_eq1 = '1') then
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

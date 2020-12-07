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

    type fsm_state is ( wait_start, calc, done );
    signal curr_state, next_state: fsm_state;
    signal curr_r0, next_r0: std_logic_vector(12 downto 0);
    signal curr_n, next_n, curr_f, next_f: std_logic_vector(2 downto 0);

begin

    data_out <= curr_r0;

    process(curr_state, curr_r0, curr_n, curr_f, n)
    begin
    
        next_state <= curr_state;
        next_r0 <= curr_r0;
        next_n <= curr_n;
        next_f <= curr_f;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_r0 <= '0' & x"001";
                next_f <= "001";
                next_n <= n;
                
                if (start = '1') then
                    next_state <= calc;
                end if;
                
            when calc =>
                next_r0 <= std_logic_vector(TO_UNSIGNED(TO_INTEGER(unsigned(curr_r0) * unsigned(curr_f)), next_r0'length));
                next_f <= std_logic_vector(unsigned(curr_f) + 1);
                
                if (curr_f = curr_n) then
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
            curr_r0 <= (others => '0');
            curr_f <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_r0 <= next_r0;
            curr_f <= next_f;
            curr_n <= next_n;
        end if;
    
    end process;

end hlsm;

architecture fsmd of factorial is

    --Datapath signals
    signal curr_r0, next_r0: std_logic_vector(12 downto 0);
    signal curr_n, next_n, curr_f, next_f: std_logic_vector(2 downto 0);
    
    --Controller signals
    type fsm_state is ( wait_start, calc, done );
    signal curr_state, next_state: fsm_state;
    
    --Control signals
    signal mux_n, end_calc: std_logic;
    signal mux_r0, mux_f: std_logic_vector(1 downto 0);
    
begin

    --Datapath
    end_calc <= '1' when (curr_n = curr_f) else '0';
    data_out <= curr_r0;
    
    process(curr_r0, curr_n, curr_f, mux_n, mux_r0, mux_f, n)
    begin
    
        --N register
        next_n <= curr_n;
        if (mux_n = '1') then
            next_n <= n;
        end if;
        
        --F register
        next_f <= curr_f;
        if (mux_f = "01") then
            next_f <= std_logic_vector(unsigned(curr_f) + 1);
        elsif (mux_f = "10") then
            next_f <= "001";
        end if;
        
        --R0 register
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= std_logic_vector(TO_UNSIGNED(TO_INTEGER(unsigned(curr_r0) * unsigned(curr_f)), next_r0'length));
        elsif (mux_r0 = "10") then
            next_r0 <= '0' & x"001";
        end if;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_r0 <= (others => '0');
            curr_f <= (others => '0');
            curr_n <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_r0 <= next_r0;
            curr_f <= next_f;
            curr_n <= next_n;
        end if;
    
    end process;

    --Controller
    process(curr_state, start, end_calc)
    begin
    
        next_state <= curr_state;
        mux_n <= '0';
        mux_r0 <= "00";
        mux_f <= "00";
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                mux_n <= '1';
                mux_r0 <= "10";
                mux_f <= "10";
                
                if (start = '1') then
                    next_state <= calc;
                end if;
                
            when calc =>
                mux_r0 <= "01";
                mux_f <= "01";
                
                if (end_calc = '1') then
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

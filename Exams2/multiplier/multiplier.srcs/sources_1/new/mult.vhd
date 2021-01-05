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
end mult;

architecture hlsm of mult is

    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    
    signal curr_a, next_a, curr_b, next_b: std_logic_vector(7 downto 0);
    signal curr_z, next_z: std_logic_vector(15 downto 0);

begin

    z <= curr_z;

    process(curr_state, curr_a, curr_b, curr_z, a, b, start)
    begin
    
        next_state <= curr_state;
        next_a <= curr_a;
        next_b <= curr_b;
        next_z <= curr_z;
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>
                next_a <= a;
                next_b <= b;
                next_z <= (others => '0');
            
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (unsigned(curr_b) = 0) then
                    next_state <= done;
                end if;
                
            when calc =>
                next_z <= std_logic_vector(unsigned(curr_z) + unsigned(curr_a));
                next_b <= std_logic_vector(unsigned(curr_b) - 1);
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
            curr_a <= (others => '0');
            curr_b <= (others => '0');
            curr_z <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_a <= next_a;
            curr_b <= next_b;
            curr_z <= next_z;
        end if;
    
    end process;

end hlsm;

architecture fsmd of mult is

    -- Datapath signals
    signal curr_a, next_a, curr_b, next_b: std_logic_vector(7 downto 0);
    signal curr_z, next_z: std_logic_vector(15 downto 0);
    
    -- Controller description
    type fsm_state is ( wait_start, check, calc, done );
    signal curr_state, next_state: fsm_state;
    
    -- Control signals
    signal mux_b, mux_z: std_logic_vector(1 downto 0);
    signal ld_a, stop: std_logic;

begin

    z <= curr_z;
    
    -- Datapath description
    process(curr_a, curr_b, curr_z, ld_a, mux_b, mux_z, a, b)
    begin
    
        -- A register
        next_a <= curr_a;
        if (ld_a = '1') then
            next_a <= a;
        end if;
        
        -- B register
        next_b <= curr_b;
        if (mux_b = "01") then
            next_b <= std_logic_vector(unsigned(curr_b) - 1);
        elsif (mux_b = "10") then
            next_b <= b;
        end if;
        
        -- Z register
        next_z <= curr_z;
        if (mux_z = "01") then
            next_z <= std_logic_vector(unsigned(curr_z) + unsigned(curr_a));
        elsif (mux_z = "10") then
            next_z <= (others => '0');
        end if;
        
        -- Stop logic
        stop <= '0';
        if (unsigned(curr_b) = 0) then
            stop <= '1';
        end if;          
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_a <= (others => '0');
            curr_b <= (others => '0');
            curr_z <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_a <= next_a;
            curr_b <= next_b;
            curr_z <= next_z;
        end if;
    
    end process;  
    
    -- Controller description
    process(curr_state, start, stop)
    begin
    
        next_state <= curr_state;
        mux_b <= "00";
        mux_z <= "00";
        ld_a <= '0';
        ready <= '0';
        
        case curr_state is
        
            when wait_start =>                
                mux_b <= "10";
                mux_z <= "10";
                ld_a <= '1';
                
                if (start = '1') then
                    next_state <= check;
                end if;
                
            when check =>
                next_state <= calc;
                if (stop = '1') then
                    next_state <= done;
                end if;
                
            when calc =>
                mux_z <= "01";
                mux_b <= "01";
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

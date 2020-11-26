library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sqrt_fsm is
    port(
        clk, rst, start: in std_logic;
        a, b: in std_logic_vector(7 downto 0);
        ready: out std_logic;
        res: out std_logic_vector(8 downto 0)
    );
end sqrt_fsm;

architecture hlsm of sqrt_fsm is

    type fsm_state is ( wait_start, s1, s2, s3, s4, s5 );
    signal curr_state, next_state: fsm_state;
    signal curr_t1, next_t1, curr_t2, next_t2, curr_t3, next_t3, curr_res, next_res: std_logic_vector(8 downto 0);

begin

    process(curr_state, start, a, b, curr_t1, curr_t2, curr_t3, curr_res)
    begin
    
        next_state <= curr_state;
        
        next_t1 <= curr_t1;
        next_t2 <= curr_t2;
        next_t3 <= curr_t3;
        next_res <= curr_res;
        
        case curr_state is
        
            when wait_start =>
                next_t1 <= a(7) & a;
                next_t2 <= b(7) & b;
                
                if (start = '1') then
                    next_state <= s1;
                end if;
                
            when s1 =>
                ready <= '0';
            
                if (signed(curr_t1) < 0) then
                    next_t1 <= std_logic_vector(unsigned(not(curr_t1)) + 1);
                end if;
        
                if (signed(curr_t2) < 0) then
                    next_t2 <= std_logic_vector(unsigned(not(curr_t2)) + 1);
                end if;
        
                next_state <= s2;
            
            when s2 =>
                if (unsigned(curr_t2) < unsigned(curr_t1)) then
                    next_t1 <= curr_t2;
                end if;
                
                if (unsigned(curr_t1) > unsigned(curr_t2)) then
                    next_t2 <= curr_t1;
                end if;
                
                if (unsigned(curr_t1) > unsigned(curr_t2)) then
                    next_t3 <= "000" & curr_t1(8 downto 3);
                else 
                    next_t3 <= "000" & curr_t2(8 downto 3);
                end if;
            
                next_state <= s3;
            
            when s3 =>
                next_t1 <= '0' & curr_t1(8 downto 1);
                next_t3 <= std_logic_vector(unsigned(curr_t2) - unsigned(curr_t3));
                
                next_state <= s4;
                
            when s4 =>
                next_t1 <= std_logic_vector(unsigned(curr_t1) + unsigned(curr_t3));
                
                next_state <= s5;
            
            when s5 =>
                next_res <= curr_t1;
                ready <= '1';
                
                if (unsigned(curr_t2) > unsigned(curr_t1)) then 
                    next_res <= curr_t2;
                end if;    
            
                next_state <= wait_start;
            
        end case;
    
    end process;
    
    res <= curr_res;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_start;
                curr_t1 <= (others => '0');
                curr_t2 <= (others => '0');
                curr_t3 <= (others => '0');
                curr_res <= (others => '0');
            else
                curr_state <= next_state;
                curr_t1 <= next_t1;
                curr_t2 <= next_t2;
                curr_t3 <= next_t3;
                curr_res <= next_res;
            end if;
        end if;
    
    end process;

end hlsm;

architecture fsmd of sqrt_fsm is

    --Datapath signals
    signal curr_t1, next_t1, curr_t2, next_t2, curr_t3, next_t3, curr_res, next_res: std_logic_vector(8 downto 0);
    signal min_val, max_val: std_logic_vector(8 downto 0);
    
    --Controller signals
    type fsm_state is ( wait_start, s1, s2, s3, s4, s5 );
    signal curr_state, next_state: fsm_state;
    
    --Control signals
    signal ld_t1, ld_t2: std_logic;
    signal ld_t1_abs, ld_t1_min, ld_t1_max, ld_t1_sh2, ld_t1_add: std_logic;
    signal ld_t2_abs, ld_t2_max: std_logic;
    signal ld_t3_max_sh3, ld_t3_sub: std_logic;
    signal ld_res: std_logic;
    
begin
    
    --Datapath description
    min_val <= curr_t2 when (unsigned(curr_t2) < unsigned(curr_t1)) else curr_t1;
    max_val <= curr_t2 when (unsigned(curr_t2) > unsigned(curr_t1)) else curr_t1;
    
    process(curr_t1, curr_t2, min_val, max_val, curr_t3, a, b, ld_t1, ld_t2, ld_t1_abs, ld_t1_min, ld_t1_max, ld_t1_sh2, ld_t1_add, ld_t2_abs, ld_t2_max, ld_t3_max_sh3, ld_t3_sub, ld_res)
    begin
    
        --T1 register
        next_t1 <= curr_t1;
    
        if (ld_t1 = '1') then
            next_t1 <= a(7) & a;
        else
            
            if (ld_t1_abs = '1') then
                if (signed(curr_t1) < 0) then
                    next_t1 <= std_logic_vector(unsigned(not(curr_t1)) + 1);
                end if;
            elsif (ld_t1_min = '1') then
                next_t1 <= min_val;
            elsif (ld_t1_max = '1') then
                next_t2 <= max_val;
            elsif (ld_t1_sh2 = '1') then
                next_t1 <= '0' & curr_t1(8 downto 1);
            elsif (ld_t1_add = '1') then
                next_t1 <= std_logic_vector(unsigned(curr_t1) + unsigned(curr_t3));
            end if;
        
        end if;
        
        --T2 register
        next_t2 <= curr_t2;
        
        if (ld_t2 = '1') then
            next_t2 <= b(7) & b;
        else
        
            if (ld_t2_abs = '1') then
                if (signed(curr_t2) < 0) then
                    next_t2 <= std_logic_vector(unsigned(not(curr_t2)) + 1);
                end if;
            elsif (ld_t2_max = '1') then
                next_t2 <= max_val;
            end if;
        
        end if;
        
        --T3 register
        next_t3 <= curr_t3;
        
        if (ld_t3_max_sh3 = '1') then
            next_t3 <= "000" & max_val(8 downto 3);
        elsif (ld_t3_sub = '1') then
            next_t3 <= std_logic_vector(unsigned(curr_t2) - unsigned(curr_t3));
        end if;
        
        --Res register
        next_res <= curr_res;
        
        if (ld_res = '1') then
             next_res <= max_val;
        end if;
    
    end process;
    
    res <= curr_res;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_t1 <= (others => '0');
                curr_t2 <= (others => '0');
                curr_t3 <= (others => '0');
                curr_res <= (others => '0');
            else
                curr_t1 <= next_t1;
                curr_t2 <= next_t2;
                curr_t3 <= next_t3;
                curr_res <= next_res;
            end if;
        end if;
        
    end process;
    
    --Controller description
    process(curr_state, start)
    begin
    
        next_state <= curr_state;
        ld_t1 <= '0';
        ld_t2 <= '0';
        ld_t1_abs <= '0';
        ld_t2_abs <= '0';
        ld_t1_min <= '0';
        ld_t2_max <= '0';
        ld_t3_max_sh3 <= '0';
        ld_t1_sh2 <= '0';
        ld_t3_sub <= '0';
        ld_t1_add <= '0';
        ld_t1_max <= '0';
        ld_res <= '0';
        
        case curr_state is
        
            when wait_start =>
                ld_t1 <= '1';
                ld_t2 <= '1';
                
                if (start = '1') then
                    next_state <= s1;
                end if;
                
            when s1 =>
                ld_t1_abs <= '1';
                ld_t2_abs <= '1';
                ready <= '0';
                
                next_state <= s2;
            
            when s2 =>
                ld_t1_min <= '1';
                ld_t2_max <= '1';
                ld_t3_max_sh3 <= '1';
                
                next_state <= s3;
            
            when s3 =>
                ld_t1_sh2 <= '1';
                ld_t3_sub <= '1';
                
                next_state <= s4;
                
            when s4 =>
                ld_t1_add <= '1';
                
                next_state <= s5;
            
            when s5 =>
                ld_t1_max <= '1';
                ld_res <= '1';
                ready <= '1';
                
                next_state <= wait_start;
        
        end case;
    
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_start;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end fsmd;

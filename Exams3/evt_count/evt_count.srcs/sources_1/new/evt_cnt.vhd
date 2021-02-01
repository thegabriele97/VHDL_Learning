library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity evt_cnt is
    port(
        clk, rst, B: in std_logic;
        C: out std_logic_vector(15 downto 0)
    );
end evt_cnt;

architecture hlsm of evt_cnt is

    type fsm_state is ( init, wait_0, wait_1, got_1, got_0 );
    signal curr_state, next_state: fsm_state;

    signal curr_cnt, next_cnt: std_logic_vector(15 downto 0);

begin

    C <= curr_cnt;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= init;
            curr_cnt <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_cnt <= next_cnt;
        end if;
    
    end process;

    process(curr_state, curr_cnt, B)
    begin
    
        next_state <= curr_state;
        next_cnt <= curr_cnt;
        
        case curr_state is
        
            when init =>
                next_state <= wait_0;
                if (B = '0') then
                    next_state <= wait_1;
                end if;
                
            when wait_0 =>
                if (B = '0') then
                    next_state <= got_0;
                end if;
                
            when wait_1 =>
                if (B = '1') then
                    next_state <= got_1;
                end if;                
        
            when got_0 =>
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                next_state <= wait_1;
        
            when got_1 =>
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                next_state <= wait_0;            
        
            when others =>
                next_state <= init;
    
        end case;
    
    end process;

end hlsm;

architecture fsmd of evt_cnt is

    -- Datapath signals 
    signal curr_cnt, next_cnt: std_logic_vector(15 downto 0);    

    -- Controller signals
    type fsm_state is ( init, wait_0, wait_1, got_1, got_0 );
    signal curr_state, next_state: fsm_state;
    
    -- Control signals
    signal ld_cnt: std_logic;

begin

    process(curr_cnt, ld_cnt)
    begin
    
        next_cnt <= curr_cnt;
        if (ld_cnt = '1') then
            next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
        end if;
        
        C <= curr_cnt;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_cnt <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_cnt <= next_cnt;
        end if;
    
    end process;
    

    process(curr_state, B)
    begin
    
        next_state <= curr_state;
        ld_cnt <= '0';
        
        case curr_state is
        
            when init =>
                next_state <= wait_0;
                if (B = '0') then
                    next_state <= wait_1;
                end if;
                
            when wait_0 =>
                if (B = '0') then
                    next_state <= got_0;
                end if;
                
            when wait_1 =>
                if (B = '1') then
                    next_state <= got_1;
                end if;                
        
            when got_0 =>
                ld_cnt <= '1';
                next_state <= wait_1;
        
            when got_1 =>
                ld_cnt <= '1';
                next_state <= wait_0;            
        
            when others =>
                next_state <= init;
    
        end case;
    
    end process;    
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= init;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end fsmd;
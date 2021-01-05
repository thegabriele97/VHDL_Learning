library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity EvtCount is
    port(
        clk, rst, B: in std_logic;
        C: out std_logic_vector(15 downto 0)
    );
end EvtCount;

architecture hlsm of EvtCount is

    type fsm_state is ( init, wait_hl, wait_lh, got_hl, got_lh );
    signal curr_state, next_state: fsm_state;
    
    signal curr_cnt, next_cnt: std_logic_vector(15 downto 0);

begin

    C <= curr_cnt;

    process(curr_state, curr_cnt, B)
    begin
    
        next_state <= curr_state;
        next_cnt <= curr_cnt;
        
        case curr_state is
        
            when init =>
                next_state <= wait_lh;
                if (B = '1') then
                    next_state <= wait_hl;
                end if;
                
            when wait_hl =>
                if (B = '0') then
                    next_state <= got_hl;
                end if;
                
            when got_hl =>
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                
                next_state <= wait_lh;
                if (B = '1') then
                    next_state <= got_lh;
                end if;
            
            when wait_lh =>
                if (B = '1') then
                    next_state <= got_lh;
                end if;
                
            when got_lh =>
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                
                next_state <= wait_hl;
                if (B = '0') then
                    next_state <= got_hl;
                end if;
                
            when others =>
                next_state <= init;
            
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= init;
            curr_cnt <= x"0000";
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_cnt <= next_cnt;
        end if;
    
    end process;

end hlsm;

architecture fsmd of EvtCount is

    -- Datapath signals
    signal curr_cnt, next_cnt: std_logic_vector(15 downto 0);
    
    -- Controller signals
    type fsm_state is ( init, wait_hl, wait_lh, got_hl, got_lh );
    signal curr_state, next_state: fsm_state;    
    
    -- Control signals
    signal ld_cnt: std_logic;

begin

    -- Datapath description
    process(curr_cnt, ld_cnt)
    begin
    
        -- CNT register
        next_cnt <= curr_cnt;
        if (ld_cnt = '1') then
            next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
        end if; 
    
        C <= curr_cnt;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_cnt <= x"0000";
        elsif (rising_edge(clk)) then
            curr_cnt <= next_cnt;
        end if;
    
    end process;
    
    -- Controller description
    process(curr_state, B)
    begin
    
        next_state <= curr_state;
        ld_cnt <= '0';
        
        case curr_state is
        
            when init =>
                next_state <= wait_lh;
                if (B = '1') then
                    next_state <= wait_hl;
                end if;
                
            when wait_hl =>
                if (B = '0') then
                    next_state <= got_hl;
                end if;
                
            when got_hl =>
                ld_cnt <= '1';
                
                next_state <= wait_lh;
                if (B = '1') then
                    next_state <= got_lh;
                end if;
            
            when wait_lh =>
                if (B = '1') then
                    next_state <= got_lh;
                end if;
                
            when got_lh =>
                ld_cnt <= '1';
                
                next_state <= wait_hl;
                if (B = '0') then
                    next_state <= got_hl;
                end if;
                
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

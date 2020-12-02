library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    generic (
        m: integer := 4
    );
    port(
        clk, rst, wr, rd: in std_logic;
        full, empty, w_en: out std_logic;
        w_addr, r_addr: out std_logic_vector((m-1) downto 0)
    );
end controller;

architecture fsmd_d of controller is

    --Controller signals
    type fsm_state is ( s_empty, s_write, s_read, s_full, s_idle, s_rw );
    signal curr_state, next_state: fsm_state;
    
    --Datapath signals
    signal curr_w_addr, next_w_addr, curr_r_addr, next_r_addr: std_logic_vector((m-1) downto 0);
    
    --Control signals
    signal ld_w_addr, ld_r_addr, addr_eq: std_logic;

begin

    --Datapath
    addr_eq <= '1' when (next_w_addr = next_r_addr) else '0';
    w_addr <= curr_w_addr;
    r_addr <= curr_r_addr;
    
    process(ld_w_addr, ld_r_addr, curr_w_addr, curr_r_addr)
    begin
    
        --W register
        next_w_addr <= curr_w_addr;
        
        if (ld_w_addr = '1') then
            next_w_addr <= std_logic_vector(unsigned(curr_w_addr) + 1);
        end if;
        
        --R register
        next_r_addr <= curr_r_addr;
        
        if (ld_r_addr = '1') then
            next_r_addr <= std_logic_vector(unsigned(curr_r_addr) + 1);
        end if;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_w_addr <= (others => '0');
            curr_r_addr <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_w_addr <= next_w_addr;
            curr_r_addr <= next_r_addr;
        end if;
    
    end process;

    --Controller
    process(curr_state, wr, rd, addr_eq)
    begin
    
        next_state <= curr_state;
        full <= '0';
        empty <= '0';
        w_en <= '0';
        ld_w_addr <= '0';
        ld_r_addr <= '0';
        
        case curr_state is
        
            when s_empty =>
                empty <= '1';
                
                if (wr = '1') then
                    next_state <= s_write;
                end if;
                
            when s_write =>
                ld_w_addr <= '1';
                w_en <= '1';
                
                if (rd = '1' and wr = '1') then
                    next_state <= s_rw;
                elsif (rd = '1') then  
                    next_state <= s_read;
                elsif (wr = '1' and addr_eq = '1') then
                    next_state <= s_full;
                elsif (wr = '0' and rd = '0') then
                    next_state <= s_idle;
                end if;
                
            when s_read =>
                ld_r_addr <= '1';
                
                if (rd = '1' and wr = '1') then
                    next_state <= s_rw;
                elsif (wr = '1') then
                    next_state <= s_write;
                elsif (rd = '1' and addr_eq = '1') then
                    next_state <= s_empty;
                elsif (rd = '0' and wr = '0') then
                    next_state <= s_idle;
                end if;
        
            when s_full =>
                full <= '1';
                
                if (rd = '1') then
                    next_state <= s_read;
                end if;
                
            when s_rw =>
                ld_r_addr <= '1';
                ld_w_addr <= '1';
                w_en <= '1';
                
                if (rd = '1' and wr = '1') then
                    next_state <= s_rw;
                elsif (rd = '1' and wr = '0') then
                    next_state <= s_read;
                elsif (rd = '0' and wr = '1') then
                    next_state <= s_write;
                elsif (rd = '0' and wr = '0') then
                    next_state <= s_idle;
                end if;
                
            when s_idle =>
                
                if (rd = '1' and wr = '1') then
                    next_state <= s_rw;
                elsif (rd = '1') then
                    next_state <= s_read;
                elsif (wr = '1') then
                    next_state <= s_write;
                end if;
                
            when others => 
                next_state <= s_empty;
                
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= s_empty;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;    
    
    end process;

end fsmd_d;
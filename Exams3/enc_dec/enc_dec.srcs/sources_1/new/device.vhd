library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity device is
    port(
        clk, rst, e, b, d: in std_logic;
        I: in std_logic_vector(15 downto 0);
        O: out std_logic_vector(15 downto 0)
    );
end device;

architecture hlsm of device is

    type fsm_state is ( cmd, str, enc, dec );
    signal curr_state, next_state: fsm_state;
    
    signal curr_i, next_i: std_logic_vector(15 downto 0);
    signal curr_r0, next_r0: std_logic_vector(15 downto 0);
    signal curr_r1, next_r1: std_logic_vector(15 downto 0);

begin

    process(curr_state, curr_r0, curr_r1, curr_i, I, e, b, d)
    begin
    
        next_state <= curr_state;
        next_r0 <= curr_r0;
        next_i <= curr_i;
        next_r1 <= curr_r1;
    
        case curr_state is
        
            when cmd => 
                next_i <= i;
                
                if (b = '1') then
                    next_state <= str;
                elsif (e = '1' and b = '0') then
                    next_state <= enc;
                elsif (d = '1' and b = '0' and e = '0') then
                    next_state <= dec;
                end if;
                
            when str =>
                next_r0 <= curr_i;
                next_state <= cmd;
                
            when enc =>
                next_r1 <= std_logic_vector(signed(curr_i) + signed(curr_r0));
                next_state <= cmd;
            
            when dec =>
                next_r1 <= std_logic_vector(signed(curr_i) - signed(curr_r0));
                next_state <= cmd;                
        
            when others =>
                next_state <= cmd;
        
        end case;
    
    end process;

    O <= curr_r1;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= cmd;
            curr_i <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_i <= next_i;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;

end hlsm;

architecture fsmd of device is

    -- Datapath signals    
    signal curr_i, next_i: std_logic_vector(15 downto 0);
    signal curr_r0, next_r0: std_logic_vector(15 downto 0);
    signal curr_r1, next_r1: std_logic_vector(15 downto 0);

    -- Controller signals
    type fsm_state is ( cmd, str, enc, dec );
    signal curr_state, next_state: fsm_state;

    -- Control signals
    signal ld_i, ld_r0: std_logic;
    signal mux_r1: std_logic_vector(1 downto 0);

begin

    process(curr_r0, curr_r1, curr_i, I, ld_i, ld_r0, mux_r1)
    begin
    
        next_i <= curr_i;
        if (ld_i = '1') then
            next_i <= I;
        end if;
        
        next_r0 <= curr_r0;
        if (ld_r0 = '1') then
            next_r0 <= curr_i;
        end if;
        
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= std_logic_vector(signed(curr_i) + signed(curr_r0));
        elsif (mux_r1 = "10") then
            next_r1 <= std_logic_vector(signed(curr_i) - signed(curr_r0));
        end if;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_i <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_i <= next_i;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;
    
    O <= curr_r1;
    
    process(curr_state, e, b, d)
    begin
    
        next_state <= curr_state;
        ld_i <= '0';
        ld_r0 <= '0';
        mux_r1 <= "00";
    
        case curr_state is
        
            when cmd => 
                ld_i <= '1';
                
                if (b = '1') then
                    next_state <= str;
                elsif (e = '1' and b = '0') then
                    next_state <= enc;
                elsif (d = '1' and b = '0' and e = '0') then
                    next_state <= dec;
                end if;
                
            when str =>
                ld_r0 <= '1';
                next_state <= cmd;
                
            when enc =>
                mux_r1 <= "01";
                next_state <= cmd;
            
            when dec =>
                mux_r1 <= "10";
                next_state <= cmd;                
        
            when others =>
                next_state <= cmd;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= cmd;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end fsmd;

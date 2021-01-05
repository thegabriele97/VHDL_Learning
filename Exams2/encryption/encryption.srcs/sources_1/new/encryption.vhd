library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity encryption is
    port(
        clk, rst, b, e, d: in std_logic;
        I: in std_logic_vector(15 downto 0);
        O: out std_logic_vector(15 downto 0)
    );
end encryption;

architecture hlsm of encryption is

    type fsm_state is ( wait_cmd, store, enc, dec );
    signal curr_state, next_state: fsm_state;
    
    signal curr_key, next_key, curr_input, next_input, curr_output, next_output: std_logic_vector(15 downto 0);

begin

    O <= curr_output;

    process(curr_state, curr_key, curr_input, curr_output, I, e, b, d)
    begin
    
        next_state <= curr_state;
        next_key <= curr_key;
        next_input <= curr_input;
        next_output <= curr_output;
    
        case curr_state is
        
            when wait_cmd =>
                next_input <= I;
                
                if (e = '1') then
                    next_state <= enc;
                elsif (d = '1') then
                    next_state <= dec;
                elsif (b = '1') then
                    next_state <= store;
                end if;
            
            when store =>
                next_key <= curr_input;
                next_state <= wait_cmd;
                
            when enc =>
                next_output <= std_logic_vector(unsigned(curr_input) + unsigned(curr_key));
                next_state <= wait_cmd;
        
            when dec =>
                next_output <= std_logic_vector(unsigned(curr_input) - unsigned(curr_key));
                next_state <= wait_cmd;
                
            when others =>
                next_state <= wait_cmd;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_cmd;
            curr_key <= (others => '0');
            curr_input <= (others => '0');
            curr_output <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_key <= next_key;
            curr_input <= next_input;
            curr_output <= next_output;
        end if;
    
    end process;

end hlsm;

architecture fsmd of encryption is

    -- Datapath signals
    signal curr_key, next_key, curr_input, next_input, curr_output, next_output: std_logic_vector(15 downto 0);
    
    -- Controller description
    type fsm_state is ( wait_cmd, store, enc, dec );
    signal curr_state, next_state: fsm_state;
    
    -- Control signals
    signal mux_output: std_logic_vector(1 downto 0);
    signal ld_key, ld_input: std_logic;

begin
    
    -- Datapath description
    process(curr_key, curr_input, curr_output, I, mux_output, ld_key, ld_input)
    begin
    
        -- KEY register
        next_key <= curr_key;
        if (ld_key = '1') then
            next_key <= curr_input;
        end if;
        
        -- INPUT register
        next_input <= curr_input;
        if (ld_input = '1') then
            next_input <= I;
        end if;
        
        -- OUTPUT register
        next_output <= curr_output;
        if (mux_output = "01") then
            next_output <= std_logic_vector(unsigned(curr_input) + unsigned(curr_key));
        elsif (mux_output = "10") then
            next_output <= std_logic_vector(unsigned(curr_input) - unsigned(curr_key));
        end if;
    
        O <= curr_output;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_key <= (others => '0');
            curr_input <= (others => '0');
            curr_output <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_key <= next_key;
            curr_input <= next_input;
            curr_output <= next_output;
        end if;
    
    end process;    
    
    -- Controller description
    process(curr_state, b, e, d)
    begin
    
        next_state <= curr_state;
        mux_output <= "00";
        ld_input <= '0';
        ld_key <= '0';
        
        case curr_state is
        
            when wait_cmd =>
                ld_input <= '1';
        
                if (e = '1') then
                    next_state <= enc;
                elsif (d = '1') then
                    next_state <= dec;
                elsif (b = '1') then
                    next_state <= store;
                end if;
                
            when store =>
                ld_key <= '1';
                next_state <= wait_cmd;
                
            when enc =>
                mux_output <= "01";
                next_state <= wait_cmd;
            
            when dec =>
                mux_output <= "10";
                next_state <= wait_cmd;
            
            when others =>
                next_state <= wait_cmd;
        
        end case;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_cmd;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;    

end fsmd;

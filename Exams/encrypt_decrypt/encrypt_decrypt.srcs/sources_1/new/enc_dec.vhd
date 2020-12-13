library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity enc_dec is
    port(
        clk, rst, b, e, d: in std_logic;
        i: in std_logic_vector(15 downto 0);
        o: out std_logic_vector(15 downto 0)
    );
end enc_dec;

architecture hlsm of enc_dec is

    type fsm_state is ( cmd, store, encrypt, decrypt );
    signal curr_state, next_state: fsm_state;
    signal curr_key, next_key, curr_i, next_i, curr_out, next_out: std_logic_vector(15 downto 0);

begin

    o <= curr_out;

    process(curr_state, curr_key, curr_out, curr_i, b, e, d, i)
    begin
    
        next_state <= curr_state;
        next_key <= curr_key;
        next_out <= curr_out;
        next_i <= curr_i;
        
        case curr_state is
        
            when cmd =>
                next_i <= i;
                
                if (b = '1') then
                    next_state <= store;
                elsif (b = '0' and e = '1') then
                    next_state <= encrypt;
                elsif (b = '0' and e = '0' and d = '1') then
                    next_state <= decrypt;
                end if;
        
            when store =>
                next_key <= curr_i;
                next_state <= cmd;
            
            when encrypt =>
                next_out <= std_logic_vector(signed(curr_i) + signed(curr_key));
                next_state <= cmd;
                
            when decrypt =>
                next_out <= std_logic_vector(signed(curr_i) - signed(curr_key));
                next_state <= cmd;
                
            when others =>
                next_state <= cmd;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= cmd;
            curr_key <= (others => '0');
            curr_out <= (others => '0');
            curr_i <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_key <= next_key;
            curr_out <= next_out;
            curr_i <= next_i;
        end if;
    
    end process;

end hlsm;

architecture fsmd of enc_dec is

    --Datapath signals
    signal curr_key, next_key, curr_i, next_i, curr_out, next_out: std_logic_vector(15 downto 0);
    
    --Control signals
    type fsm_state is ( cmd, store, encrypt, decrypt );
    signal curr_state, next_state: fsm_state;
    
    --Control signals
    signal ld_i, ld_key: std_logic;
    signal mux_out: std_logic_vector(1 downto 0);

begin

    --Datapath
    o <= curr_out;
    
    process(curr_key, curr_out, curr_i, ld_i, ld_key, mux_out, i)
    begin
    
        --I register
        next_i <= curr_i;
        if (ld_i = '1') then
            next_i <= i;
        end if;
        
        --Key register
        next_key <= curr_key;
        if (ld_key = '1') then
            next_key <= curr_i;
        end if;
        
        --Out register
        next_out <= curr_out;
        if (mux_out = "01") then
            next_out <= std_logic_vector(signed(curr_i) + signed(curr_key));
        elsif (mux_out = "10") then
            next_out <= std_logic_vector(signed(curr_i) - signed(curr_key));
        end if;
    
    end process;
    
    process(clk, rst)
        begin
    
        if (rst = '1') then
            curr_key <= (others => '0');
            curr_out <= (others => '0');
            curr_i <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_key <= next_key;
            curr_out <= next_out;
            curr_i <= next_i;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, b, e, d)
    begin
    
        next_state <= curr_state;
        ld_i <= '0';
        ld_key <= '0';
        mux_out <= "00";
        
        case curr_state is
        
            when cmd =>
                ld_i <= '1';
                
                if (b = '1') then
                    next_state <= store;
                elsif (b = '0' and e = '1') then
                    next_state <= encrypt;
                elsif (b = '0' and e = '0' and d = '1') then
                    next_state <= decrypt;
                end if;
                
            when store =>
                ld_key <= '1';
                next_state <= cmd;
                
            when encrypt =>
                mux_out <= "01";
                next_state <= cmd;
                
            when decrypt =>
                mux_out <= "10";
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
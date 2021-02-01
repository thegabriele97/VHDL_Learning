library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity speeder is
    port(
        clk, rst, up, down: in std_logic;
        S: out std_logic_vector(3 downto 0)
    );
end speeder;

architecture hlsm of speeder is

    type fsm_state is ( init, pause, go_up, go_dw );
    signal curr_state, next_state: fsm_state;
    signal curr_speed, next_speed: std_logic_vector(3 downto 0);

begin
    
    S <= curr_speed;
    
    process(curr_speed, curr_state, up, down)
    begin
    
        next_state <= curr_state;
        next_speed <= curr_speed;
        
        case curr_state is
        
            when init =>
                next_speed <= (others => '0');
                next_state <= pause;
            
            when pause =>
                if (up = '1' and down = '0' and unsigned(curr_speed) < 15) then
                    next_state <= go_up;
                elsif (up = '0'and down = '1' and unsigned(curr_speed) > 0) then
                    next_state <= go_dw;
                end if;
                
            when go_up =>
                next_speed <= std_logic_vector(unsigned(curr_speed) + 1);
                
                if ((down = '0' and unsigned(curr_speed) = 14) or (up = '1' and down = '1') or (up = '0' and down = '0')) then
                    next_state <= pause;
                elsif (up = '0' and down = '1') then
                    next_state <= go_dw;
                end if;
                
            when go_dw =>
                next_speed <= std_logic_vector(unsigned(curr_speed) - 1);
                
                if ((up = '0' and curr_speed = x"1") or (up = '1' and down = '1') or (up = '0' and down = '0')) then
                    next_state <= pause;
                elsif (up = '1' and down = '0') then
                    next_state <= go_up;
                end if;             
        
            when others => 
                next_state <= init;
        
        end case;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= init;
            curr_speed <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_speed <= next_speed;
        end if;
    
    end process;

end hlsm;

architecture fsmd of speeder is

    -- Datapath signals
    signal curr_speed, next_speed: std_logic_vector(3 downto 0);

    -- Controller signals
    type fsm_state is ( init, pause, go_up, go_dw );
    signal curr_state, next_state: fsm_state;

    -- Control signals
    signal mux_speed: std_logic_vector(1 downto 0);
    signal eq_15, eq_14, eq_1, eq_0: std_logic;
    
begin

    S <= curr_speed;
    
    process(curr_speed, mux_speed)
    begin
    
        next_speed <= curr_speed;
        if (mux_speed = "01") then
            next_speed <= std_logic_vector(unsigned(curr_speed) + 1);
        elsif (mux_speed = "10") then
            next_speed <= std_logic_vector(unsigned(curr_speed) - 1);
        elsif (mux_speed = "11") then
            next_speed <= (others => '0');
        end if;
        
        eq_15 <= '0';
        if (curr_speed = x"f") then
            eq_15 <= '1';
        end if;
        
        eq_14 <= '0';
        if (curr_speed = x"e") then
            eq_14 <= '1';
        end if;
        
        eq_1 <= '0';
        if (curr_speed = x"1") then
            eq_1 <= '1';
        end if;
        
        eq_0 <= '0';
        if (curr_speed = x"0") then
            eq_0 <= '1';
        end if;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_speed <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_speed <= next_speed;
        end if;
    
    end process;

    process(curr_state, up, down, eq_14, eq_1, eq_0)
    begin
    
        next_state <= curr_state;
        mux_speed <= "00";
        
        case curr_state is
        
            when init =>
                mux_speed <= "11";
                next_state <= pause;
            
            when pause =>
                if (up = '1' and down = '0' and eq_15 = '0') then
                    next_state <= go_up;
                elsif (up = '0'and down = '1' and eq_0 = '0') then
                    next_state <= go_dw;
                end if;
                
            when go_up =>
                mux_speed <= "01";
                
                if ((down = '0' and eq_14 = '1') or (up = '1' and down = '1') or (up = '0' and down = '0')) then
                    next_state <= pause;
                elsif (up = '0' and down = '1') then
                    next_state <= go_dw;
                end if;
                
            when go_dw =>
                mux_speed <= "10";
                
                if ((up = '0' and eq_1 = '1') or (up = '1' and down = '1') or (up = '0' and down = '0')) then
                    next_state <= pause;
                elsif (up = '1' and down = '0') then
                    next_state <= go_up;
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

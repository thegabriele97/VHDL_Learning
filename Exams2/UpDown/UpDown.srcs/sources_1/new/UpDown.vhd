library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity UpDown is
    port(
        clk, rst, Up, Down: in std_logic;
        Speed: out std_logic_vector(3 downto 0)
    );
end UpDown;

architecture hlsm of UpDown is

    type fsm_state is ( wait_up, go_up, go_down, wait_down, wait_4eva );
    signal curr_state, next_state: fsm_state;

    signal curr_speed, next_speed: std_logic_vector(3 downto 0);

begin

    Speed <= curr_speed;

    process(curr_state, curr_speed, Up, Down)
    begin
    
        next_state <= curr_state;
        next_speed <= curr_speed;
        
        case curr_state is
    
            when wait_up =>
                if (up = '1' and down /= up) then
                    next_state <= go_up;
                end if;
                
            when go_up =>
                next_speed <= std_logic_vector(unsigned(curr_speed) + 1);
                
                if (up = '1' and curr_speed = x"e") then
                    next_state <= wait_down;
                elsif (up = down) then
                    next_state <= wait_4eva;
                elsif (down = '1') then
                    next_state <= go_down;
                end if;
    
            when go_down =>
                next_speed <= std_logic_vector(unsigned(curr_speed) - 1);
                
                if (down = '1' and curr_speed = x"1") then
                    next_state <= wait_up;
                elsif (up = down) then
                    next_state <= wait_4eva;
                elsif (up = '1') then
                    next_state <= go_up;
                end if;
                
            when wait_down =>
                if (down = '1' and down /= up) then
                    next_state <= go_down;
                end if;
                
            when wait_4eva =>
                if (not up = down) then
                    if (up = '1') then
                        next_state <= go_up;
                    elsif (down = '1') then
                        next_state <= go_down;
                    end if;
                end if;
    
            when others =>
                next_state <= wait_up;
    
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_up;
            curr_speed <= x"0";
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_speed <= next_speed;
        end if;
    
    end process;

end hlsm;

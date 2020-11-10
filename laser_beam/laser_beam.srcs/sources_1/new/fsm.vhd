library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsm is
    port(
        clk, rst, btn, laser_reflect: in std_logic;
        laser_on: out std_logic;
        measure: out std_logic_vector(15 downto 0)
    );
end fsm;

architecture Behavioral of fsm is

    type fsm_state is ( init, wait_btn, turn_laser_on, wait_laser_reflect, received_laser_reflect );
    signal curr_state, next_state: fsm_state;
    signal curr_cnt, next_cnt, curr_measure, next_measure: std_logic_vector(15 downto 0);

begin

    process(curr_state, curr_cnt, btn, laser_reflect)
    begin
    
        next_state <= curr_state;
        laser_on <= '0';
    
        case curr_state is
        
            when init =>
                next_cnt <= (others => '0');
                next_measure <= (others => '0');
                next_state <= wait_btn;
            
            when wait_btn =>
                if (btn = '1') then
                    next_state <= turn_laser_on;
                end if;
                
            when turn_laser_on =>
                laser_on <= '1';
                next_state <= wait_laser_reflect;
                
            when wait_laser_reflect =>
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                
                if (laser_reflect = '1') then
                    next_state <= received_laser_reflect;
                end if;
                
            when received_laser_reflect =>
                next_measure <= '0' & curr_cnt(15 downto 1);
                next_state <= wait_btn;
            
            when others =>
                next_state <= init;
                        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init;
                curr_cnt <= (others => '0');
                curr_measure <= (others => '0');
            else
                curr_state <= next_state;
                curr_cnt <= next_cnt;
                curr_measure <= next_measure;
            end if;
        end if;
    
    end process;
    
    measure <= curr_measure;

end Behavioral;

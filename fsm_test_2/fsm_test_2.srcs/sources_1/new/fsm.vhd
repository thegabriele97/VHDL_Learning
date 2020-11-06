library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsm is
    port(
        clk, rst, b: in std_logic;
        x: out std_logic
    );
end fsm;

architecture Behavioral of fsm is

    type fsm_state is ( off_state, on_state );
    signal curr_state, next_state: fsm_state;
    signal curr_cnt, next_cnt: std_logic_vector(1 downto 0);

begin

    process(curr_state, curr_cnt, b)
    begin
        
        next_state <= curr_state;
        case curr_state is
        
            when off_state =>
                x <= '0';
                next_cnt <= (others => '0');
                
                if (b = '1') then
                    next_state <= on_state;
                end if;
                
            when on_state =>
                x <= '1';
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
        
                if (curr_cnt = "01") then
                    next_state <= off_state;
                end if;
                
            when others =>
                next_state <= off_state;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= off_state;
                curr_cnt <= (others => '0');
            else
                curr_state <= next_state;
                curr_cnt <= next_cnt;
            end if;
        end if;
    
    end process;

end Behavioral;

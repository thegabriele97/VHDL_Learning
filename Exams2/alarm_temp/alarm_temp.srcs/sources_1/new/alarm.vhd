library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity alarm is
    port(
        clk, rst: in std_logic;
        wt, ct: in std_logic_vector(15 downto 0);
        alarm: out std_logic
    );
end alarm;

architecture hlsm of alarm is

    type fsm_state is ( check, capt, avg, notice );
    signal curr_state, next_state: fsm_state;
    
    signal curr_wt, next_wt, curr_ct, next_ct: std_logic_vector(15 downto 0);
    signal curr_sum, next_sum: std_logic_vector(17 downto 0);
    signal curr_cnt, next_cnt: std_logic_vector(2 downto 0);

begin

    process(curr_state, curr_wt, curr_ct, curr_sum, curr_cnt, ct, wt)
    begin
    
        next_state <= curr_state;
        next_wt <= curr_wt;
        next_ct <= curr_ct;
        next_sum <= curr_sum;
        next_cnt <= curr_cnt;
        alarm <= '0';
        
        case curr_state is
        
            when check =>
                next_ct <= ct;
                next_wt <= wt;
                
                next_state <= capt;
                if (curr_cnt = "100") then
                    next_state <= avg;
                end if;
        
            when capt =>
                next_sum <= std_logic_vector(unsigned(curr_sum) + unsigned(curr_ct));
                next_cnt <= std_logic_vector(unsigned(curr_cnt) + 1);
                next_state <= check;
        
            when avg =>
                next_sum <= (others => '0');
                next_cnt <= (others => '0');
                
                next_state <= check;
                if (unsigned(curr_sum(17 downto 2)) > unsigned(curr_wt)) then
                    next_state <= notice;
                end if;
                
            when notice =>
                alarm <= '1';
                next_state <= check;
                
            when others =>
                next_state <= check;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= check;
            curr_wt <= (others => '0');
            curr_ct <= (others => '0');
            curr_sum <= (others => '0');
            curr_cnt <= (others => '0');
        elsif rising_edge(clk) then
            curr_state <= next_state;
            curr_wt <= next_wt;
            curr_ct <= next_ct;
            curr_sum <= next_sum;
            curr_cnt <= next_cnt;
        end if;
    
    end process;

end hlsm;

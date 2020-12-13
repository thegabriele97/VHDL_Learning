library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity TempCtrl is
    port(
        clk, rst: in std_logic;
        ct, wt: in std_logic_vector(15 downto 0);
        alarm: out std_logic
    );
end TempCtrl;

architecture hlsm of TempCtrl is

    type fsm_state is ( get_wt, sample, avg, alarm_on );
    signal curr_state, next_state: fsm_state;
    signal curr_iter, next_iter: std_logic_vector(1 downto 0);
    signal curr_sum, next_sum: std_logic_vector(16 downto 0);
    signal curr_wt, next_wt, curr_ct, next_ct: std_logic_vector(15 downto 0);

begin

    process(curr_state, curr_iter, curr_sum, curr_wt, curr_ct, ct, wt)
    begin

        next_state <= curr_state;
        next_iter <= curr_iter;
        next_sum <= curr_sum;
        alarm <= '0';

        case curr_state is

            when get_wt =>
                next_wt <= wt;
                next_ct <= ct;
                next_sum <= (others => '0');
                next_iter <= (others => '0');

                next_state <= sample;
                if (unsigned(curr_sum) > unsigned(curr_wt)) then
                    next_state <= alarm_on;
                end if;

            when sample =>
                next_sum <= std_logic_vector(unsigned(curr_sum) + unsigned(curr_ct));
                next_iter <= std_logic_vector(unsigned(curr_iter) + 1);
                next_ct <= ct;

                if (unsigned(curr_iter) = 3) then
                    next_state <= avg;
                end if;

            when avg =>
                next_sum <= "00" & curr_sum(16 downto 2);
                next_state <= get_wt;

            when alarm_on =>
                alarm <= '1';
                next_state <= get_wt;

            when others =>
                next_state <= get_wt;

        end case;

    end process;

    process(clk, rst)
    begin

        if (rst = '1') then
            curr_state <= get_wt;
            curr_iter <= (others => '0');
            curr_sum <= (others => '0');
            curr_wt <= (others => '0');
            curr_ct <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            curr_iter <= next_iter;
            curr_sum <= next_sum;
            curr_wt <= next_wt;
            curr_ct <= next_ct;
        end if;

    end process;

end hlsm;

architecture fsmd of TempCtrl is

    --Datapath signals
    signal curr_iter, next_iter: std_logic_vector(1 downto 0);
    signal curr_sum, next_sum: std_logic_vector(16 downto 0);
    signal curr_wt, next_wt, curr_ct, next_ct: std_logic_vector(15 downto 0);

    --Controller signals
    type fsm_state is ( get_wt, sample, avg, alarm_on );
    signal curr_state, next_state: fsm_state;

    --Control signals
    signal alarm_set, cnt_end: std_logic;
    signal ld_ct, ld_wt: std_logic;
    signal mux_sum, mux_iter: std_logic_vector(1 downto 0);

begin
    
    --Datapath
    process(curr_iter, curr_sum, curr_wt, curr_ct, ld_ct, ld_wt, mux_sum, mux_iter, wt, ct)
    begin
    
        --Wt register
        next_wt <= curr_wt;
        if (ld_wt = '1') then
            next_wt <= wt;
        end if;
        
        --Ct register
        next_ct <= curr_ct;
        if (ld_ct = '1') then
            next_ct <= ct;
        end if;
        
        --Sum register
        next_sum <= curr_sum;
        if (mux_sum = "01") then
            next_sum <= std_logic_vector(unsigned(curr_sum) + unsigned(curr_ct));
        elsif (mux_sum = "10") then
            next_sum <= "00" & curr_sum(16 downto 2);
        elsif (mux_sum = "11") then
            next_sum <= (others => '0');
        end if;
        
        --Iter register
        next_iter <= curr_iter;
        if (mux_iter = "01") then
            next_iter <= std_logic_vector(unsigned(curr_iter) + 1);
        elsif (mux_iter = "10") then
            next_iter <= (others => '0');
        end if;
        
        --Alarm_set logic
        alarm_set <= '0';
        if (unsigned(curr_sum) > unsigned(curr_wt)) then
            alarm_set <= '1';
        end if;
        
        --Cnt_end logic
        cnt_end <= '0';
        if (unsigned(curr_iter) = 3) then
            cnt_end <= '1';
        end if;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_iter <= (others => '0');
            curr_sum <= (others => '0');
            curr_wt <= (others => '0');
            curr_ct <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_iter <= next_iter;
            curr_sum <= next_sum;
            curr_wt <= next_wt;
            curr_ct <= next_ct;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, cnt_end, alarm_set)
    begin
    
        next_state <= curr_state;
        ld_wt <= '0';
        ld_ct <= '0';
        mux_sum <= "00";
        mux_iter <= "00";
        alarm <= '0';
        
        case curr_state is
        
            when get_wt =>
                ld_ct <= '1';
                ld_wt <= '1';
                mux_sum <= "11";
                mux_iter <= "10";
                
                next_state <= sample;
                if (alarm_set = '1') then
                    next_state <= alarm_on;
                end if;
        
            when sample =>
                ld_ct <= '1';
                mux_sum <= "01";
                mux_iter <= "01";
                
                if (cnt_end = '1') then
                    next_state <= avg;
                end if;
                
            when avg =>
                mux_sum <= "10";
                next_state <= get_wt;
                
            when alarm_on =>
                alarm <= '1';
                next_state <= get_wt;
            
            when others =>
                next_state <= get_wt;
        
        end case;
    
    end process;
    
    process(clk, rst)
        begin
    
            if (rst = '1') then
                curr_state <= get_wt;
            elsif (rising_edge(clk)) then
                curr_state <= next_state;
            end if;
    
        end process;

end fsmd;
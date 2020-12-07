library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BIST is
    port(
        clk, rst, go: in std_logic;
        data_i: in std_logic_vector(5 downto 0);
        finish, error, we: out std_logic;
        addr: out std_logic_vector(15 downto 0);
        data_o: out std_logic_vector(5 downto 0)
    );
end BIST;

architecture Behavioral of BIST is

    --Datapath
    signal curr_addr, next_addr: std_logic_vector(15 downto 0);
    signal curr_data, next_data: std_logic_vector(5 downto 0);

    --Controller
    type fsm_state is ( wait_start, wr0, wr1, rd0, rd1, err, done );
    signal curr_state, next_state: fsm_state;

    --Control signals
    signal mux_addr: std_logic_vector(1 downto 0); --00: nothing, 01: decrement, 10: load all 1's
    signal mux_data: std_logic_vector(1 downto 0); --00: nothing, 01: reg=1, 10: reg=0
    signal mux_eq, data_eq, end_addr: std_logic;

begin

    --Datapath
    data_o <= curr_data;
    addr <= curr_addr;
    
    process(curr_addr, curr_data, data_i, mux_addr, mux_data, mux_eq)
    begin
    
        --Addr register
        next_addr <= curr_addr;
        if (mux_addr = "01") then
            next_addr <= std_logic_vector(unsigned(curr_addr) - 1);
        elsif (mux_addr = "10") then
            next_addr <= (others => '1');
        end if;
        
        end_addr <= '0';
        if (unsigned(curr_addr) = 0) then
            end_addr <= '1';
        end if;
        
        --Data register
        next_data <= curr_data;
        if (mux_data = "01") then
            next_data <= std_logic_vector(TO_UNSIGNED(1, next_data'length));
        elsif (mux_addr = "10") then
            next_data <= (others => '0');
        end if;
        
        --Data comparator
        data_eq <= '0';
        if (mux_eq = '0') then
            if (unsigned(data_i) = 0) then
                data_eq <= '1';
            end if;
        elsif (mux_eq = '1') then
            if (unsigned(data_i) = 1) then
                data_eq <= '1';
            end if;
        end if;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_addr <= (others => '0');
            curr_data <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_addr <= next_addr;
            curr_data <= next_data;
        end if;
    
    end process;

    --Controller
    process(curr_state, data_eq, end_addr, go)
    begin
    
        next_state <= curr_state;
        mux_addr <= "00";
        mux_data <= "00";
        mux_eq <= '0';
        finish <= '0';
        error <= '0';
        we <= '0';
        
        case curr_state is
        
            when wait_start =>
                mux_addr <= "10";
                mux_data <= "10";
                
                if (go = '1') then
                    next_state <= wr0;
                end if;
                
            when wr0 =>
                mux_addr <= "01";
                we <= '1';
                
                if (end_addr = '1') then
                    next_state <= rd0;
                end if;
                
            when rd0 =>
                mux_addr <= "01";
                mux_data <= "01";
                mux_eq <= '0';
                
                if (end_addr = '1') then
                    next_state <= wr1;
                elsif (data_eq = '0') then
                    next_state <= err;
                end if;
                
            when wr1 =>
                mux_addr <= "01";
                we <= '1';
                
                if (end_addr = '1') then
                    next_state <= rd1;
                end if;
        
            when rd1 =>
                mux_addr <= "01";
                mux_eq <= '1';
                
                if (end_addr = '1') then
                    next_state <= done;
                elsif (data_eq = '0') then
                    next_state <= err;
                end if;
                
            when err =>
                error <= '1';
                finish <= '1';
                next_state <= wait_start;
                
            when done =>
                finish <= '1';
                next_state <= wait_start;
                
            when others =>
                next_state <= wait_start;
        
        end case;
        
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_start;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end Behavioral;

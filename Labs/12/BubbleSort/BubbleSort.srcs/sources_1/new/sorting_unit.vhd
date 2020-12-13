library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sorting_unit is
    port(
        clk, rst, go: in std_logic;
        finish, rw, error: out std_logic;
        
        addr: out std_logic_vector(2 downto 0);
        din: in std_logic_vector(3 downto 0);
        dout: out std_logic_vector(3 downto 0)
    );
end sorting_unit;

architecture Behavioral of sorting_unit is

    --Datapath signals
    signal curr_j, next_j: std_logic_vector(3 downto 0);
    signal curr_i, next_i: std_logic_Vector(2 downto 0);
    signal curr_r0, next_r0, curr_r1, next_r1: std_logic_vector(3 downto 0);
    
    --Controller signals
    type fsm_state is ( wait_go, while_j, while_i, load_r0, load_r1, cmp, swap, store_r0, store_r1, done_sort, get_r0, get_r1, check, err );
    signal curr_state, next_state: fsm_state;
    
    --Control signals
    signal mux_j, mux_i, mux_r0, mux_r1: std_logic_vector(1 downto 0);
    signal mux_str, mux_addr: std_logic;
    signal end_j, end_i, do_swap: std_logic;

begin

    --Datapath
    process(curr_j, curr_i, curr_r0, curr_r1, mux_j, mux_r0, mux_r1, mux_i, mux_str, mux_addr, din)
    begin
    
        --J register
        next_j <= curr_j;
        if (mux_j = "01") then
            next_j <= std_logic_vector(unsigned(curr_j) + 1);
        elsif (mux_j = "10") then
            next_j <= std_logic_vector(TO_UNSIGNED(1, next_j'length));
        end if;
        
        --I register
        next_i <= curr_i;
        if (mux_i = "01") then
            next_i <= std_logic_vector(unsigned(curr_i) + 1);
        elsif (mux_i = "10") then
            next_i <= (others => '0');
        end if;
    
        --R0 register
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= curr_r1;
        elsif (mux_r0 = "10") then
            next_r0 <= din; 
        end if;
    
        --R1 register
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= curr_r0;
        elsif (mux_r1 = "10") then
            next_r1 <= din;
        end if;
        
        --Store mpx logic
        dout <= curr_r0;
        if (mux_str = '1') then
            dout <= curr_r1;
        end if;
        
        --Swap logic
        do_swap <= '0';
        if (unsigned(curr_r0) > unsigned(curr_r1)) then
            do_swap <= '1';
        end if;
        
        --End j logic
        end_j <= '0';
        if (unsigned(curr_j) = 8) then
            end_j <= '1';
        end if;
        
        --End i logic
        end_i <= '0';
        if (unsigned(curr_i) = 7) then
            end_i <= '1';
        end if;
        
        --Address mpx logic
        addr <= curr_i;
        if (mux_addr = '0') then
            addr <= std_logic_vector(unsigned(curr_i) - 1);
        end if;

    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_j <= (others => '0');
            curr_i <= (others => '0');
            curr_r0 <= (others => '0');
            curr_r1 <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_j <= next_j;
            curr_i <= next_i;
            curr_r0 <= next_r0;
            curr_r1 <= next_r1;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, go, end_j, end_i, do_swap)
    begin
    
        next_state <= curr_state;
        mux_i <= "00";
        mux_j <= "00";
        mux_r0 <= "00";
        mux_r1 <= "00";
        mux_str <= '0';
        mux_addr <= '1';
        rw <= '0';
        finish <= '0';
        error <= '0';
        
        case curr_state is
        
            when wait_go =>
                mux_j <= "10";
                
                if (go = '1') then
                    next_state <= while_j;
                end if;
                
            when while_j =>
                mux_j <= "01";
                mux_i <= "10";
                
                if (end_j = '0') then
                    next_state <= while_i;
                elsif (end_j = '1') then
                    next_state <= get_r0;
                end if;
                
             when while_i =>
                if (end_i = '0') then
                    next_state <= load_r0;
                elsif (end_i = '1') then
                    next_state <= while_j;
                end if;
             
             when load_r0 =>
                mux_r0 <= "10";
                mux_i <= "01";
                next_state <= load_r1;
           
             when load_r1 =>
                mux_r1 <= "10";
                next_state <= cmp;
                
             when cmp =>
                if (do_swap = '0') then
                    next_state <= while_i;
                elsif (do_swap = '1') then
                    next_state <= swap;
                end if;
                
             when swap =>
                mux_r0 <= "01";
                mux_r1 <= "01";
                next_state <= store_r0;
                
             when store_r0 =>
                rw <= '1';
                mux_addr <= '0';
                mux_str <= '0';
                next_state <= store_r1;
                
             when store_r1 =>
                rw <= '1';
                mux_str <= '1';
                next_state <= while_i;
                
             when get_r0 =>
                mux_r0 <= "10";
                mux_i <= "01";
                
                if (end_i = '0') then
                    next_state <= get_r1;
                elsif (end_i = '1') then
                    next_state <= done_sort;
                end if;
                
             when get_r1 =>
                mux_r1 <= "10";
                next_state <= check;   
             
             when check =>
                if (do_swap = '1') then
                    next_state <= err;
                elsif (do_swap = '0') then
                    next_state <= get_r0;
                end if;
                
             when err =>
                error <= '1';
                next_state <= done_sort;
             
             when done_sort =>
                finish <= '1';
                next_state <= wait_go;
                
             when others =>
                next_state <= wait_go;
        
        end case;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_go;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end Behavioral;

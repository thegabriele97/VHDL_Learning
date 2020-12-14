----------------------------------------------------------------------------------
-- Company:     Politecnico di Torino
-- Engineer:    La Greca Salvatore Gabriele
-- 
-- Create Date: 14.12.2020 18:01:24
-- Design Name: Controller
-- Module Name: Controller
-- Project Name: Matrix Dot Product
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Controller is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        
        wreq        : in std_logic;
        wgrant      : out std_logic;
        bs          : in std_logic;
        
        goreq       : in std_logic;
        gogrant     : out std_logic;
        
        finish      : out std_logic;
        
        row0        : out std_logic_vector(4 downto 0);
        col0        : out std_logic_vector(4 downto 0);
        data0       : inout std_logic_vector(31 downto 0);
        cs0         : out std_logic;
        rw0         : out std_logic;
        oe0         : out std_logic;
        
        row1        : out std_logic_vector(4 downto 0);
        col1        : out std_logic_vector(4 downto 0);
        data1       : inout std_logic_vector(31 downto 0);
        cs1         : out std_logic;
        rw1         : out std_logic;
        oe1         : out std_logic;
        
        row2        : out std_logic_vector(4 downto 0);
        col2        : out std_logic_vector(4 downto 0);
        data2       : inout std_logic_vector(31 downto 0);
        cs2         : out std_logic;
        rw2         : out std_logic;
        oe2         : out std_logic
    );
end Controller;

architecture Behavioral of Controller is

    --Datapath signals
    signal curr_r0, next_r0, curr_c0, next_c0, curr_r1, next_r1, curr_c1, next_c1: std_logic_vector(5 downto 0);
    signal curr_r2, next_r2, curr_r3, next_r3: std_logic_vector(31 downto 0);
    signal curr_sum, next_sum: std_logic_vector(63 downto 0);
    
    signal reg_inc, inc: std_logic_vector(5 downto 0);
    
    --Controller signals
    type fsm_state is ( wait_comm, wait_wr_b0, wait_wr_b1, while_row1, while_col2, get_first, get_second, mac, store, go_on, done );
    signal curr_state, next_state: fsm_state;
    
    --Control signals
    signal mux_r0, mux_c0, mux_r1, mux_c1, mux_sum: std_logic_vector(1 downto 0);
    signal mux_inc: std_logic_vector(1 downto 0);
    signal ld_r2, ld_r3: std_logic;
    signal end_r0, end_r1, end_c1: std_logic;

begin

    --Datapath
    inc <= std_logic_vector(unsigned(reg_inc) + 1);
    end_r0 <= curr_r0(5);
    end_r1 <= curr_r1(5);
    end_c1 <= curr_c1(5);
    
    row0 <= curr_r0(4 downto 0);
    col0 <= curr_c0(4 downto 0);
    
    row1 <= curr_r1(4 downto 0);
    col1 <= curr_c1(4 downto 0);
    
    row2 <= curr_r0(4 downto 0);
    col2 <= curr_c1(4 downto 0);
    data2 <= curr_sum(47 downto 16);
    
    
    process(curr_r0, curr_r1, curr_c0, curr_c1, curr_r2, curr_r3, curr_sum, mux_r0, mux_c0, mux_r1, mux_c1, mux_sum, mux_inc, ld_r2, ld_r3, data0, data1, data2, inc)
    begin
    
        --R0 register
        next_r0 <= curr_r0;
        if (mux_r0 = "01") then
            next_r0 <= inc;
        elsif (mux_r0 = "10") then
            next_r0 <= (others => '0');
        end if;
        
        --C0 register
        next_c0 <= curr_c0;
        if (mux_c0 = "01") then
            next_c0 <= inc;
        elsif (mux_c0 = "10") then
            next_c0 <= (others => '0');
        end if;
        
        --R1 register
        next_r1 <= curr_r1;
        if (mux_r1 = "01") then
            next_r1 <= inc;
        elsif (mux_r1 = "10") then
            next_r1 <= (others => '0');
        end if;    
        
        --C1 register
        next_c1 <= curr_c1;
        if (mux_c1 = "01") then
            next_c1 <= inc;
        elsif (mux_c1 = "10") then
            next_c1 <= (others => '0');
        end if;                
        
        --Mux increment logic
        reg_inc <= curr_r0;
        if (mux_inc = "01") then
            reg_inc <= curr_c0;
        elsif (mux_inc = "10") then
            reg_inc <= curr_r1;
        elsif (mux_inc = "11") then
            reg_inc <= curr_c1;
        end if;
        
        --R2 register
        next_r2 <= curr_r2;
        if (ld_r2 = '1') then
            next_r2 <= data0;
        end if;
        
        --R3 register
        next_r3 <= curr_r3;
        if (ld_r3 = '1') then
            next_r3 <= data1;
        end if;
        
        --Sum register
        next_sum <= curr_sum;
        if (mux_sum = "01") then
            next_sum <= std_logic_vector(unsigned(curr_sum) + (unsigned(curr_r2) * unsigned(curr_r3)));
        elsif (mux_sum = "10") then
            next_sum <= (others => '0');
        end if;
        
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_r0 <= (others => '0');
                curr_r1 <= (others => '0');
                curr_r2 <= (others => '0');
                curr_r3 <= (others => '0');
                curr_c0 <= (others => '0');
                curr_c1 <= (others => '0');
                curr_sum <= (others => '0');
            else
                curr_r0 <= next_r0;
                curr_r1 <= next_r1;
                curr_r2 <= next_r2;
                curr_r3 <= next_r3;
                curr_c0 <= next_c0;
                curr_c1 <= next_c1;
                curr_sum <= next_sum;
            end if;
        end if;
    
    end process;
    
    --Controller
    process(curr_state, wreq, goreq, end_r0, end_r1, end_c1, bs)
    begin
    
        next_state <= curr_state;
        mux_r0 <= "00";
        mux_c0 <= "00";
        mux_r1 <= "00";
        mux_c1 <= "00";
        mux_sum <= "00";
        mux_inc <= "00";
        ld_r2 <= '0';
        ld_r3 <= '0';
        
        wgrant <= '0';
        gogrant <= '0';
        finish <= '0';
        
        cs0 <= '0';
        rw0 <= '1';
        oe0 <= '0';
        
        cs1 <= '0';
        rw1 <= '1';
        oe1 <= '0';
        
        cs2 <= '0';
        rw2 <= '1';
        oe2 <= '0';
        
        case curr_state is
        
            when wait_comm =>
                mux_r0 <= "10";                 -- Preparing r0 to start from 0
            
                if (wreq = '1') then
                    if (bs = '0') then
                        next_state <= wait_wr_b0;
                    elsif (bs = '1') then
                        next_state <= wait_wr_b1;
                    end if;
                elsif (goreq = '1') then
                    next_state <= while_row1;
                end if;
                
            when wait_wr_b0 =>
                wgrant <= '1';                  -- Enabling user to write into bank 0
                rw0 <= '0';
                cs0 <= '1';
                
                if (bs = '1') then
                    next_state <= wait_wr_b1;
                elsif (wreq = '0') then
                    next_state <= wait_comm;
                end if;
        
            when wait_wr_b1 =>
                wgrant <= '1';                  -- Enabling user to write into bank 1
                rw1 <= '0';
                cs1 <= '1';
                
                if (bs = '0') then
                    next_state <= wait_wr_b0;
                elsif (wreq = '0') then
                    next_state <= wait_comm;
                end if;    
        
            when while_row1 =>
                mux_c1 <= "10";                 -- Preparing c1 to start from 0
                
                next_state <= while_col2;
                if (end_r0 = '1') then
                    next_state <= done;
                end if;
                
            when while_col2 =>
                mux_c0 <= "10";
                mux_r1 <= "10";                 -- Clearing c0 and r1
                mux_sum <= "10";                -- Clearing sum register
                
                next_state <= get_first;
                if (end_c1 = '1') then
                    next_state <= go_on;
                end if;
                
            when get_first =>
                cs0 <= '1';                     -- Activating matrix0
                oe0 <= '1';                     -- Enabling output of matrix 0
                ld_r2 <= '1';                   -- Loading into r2 <- matrix0[r0][c0];
                mux_inc <= "01";                -- Selected to increment c0
                mux_c0 <= "01";                 -- Loading into c0 the new incremented value
                next_state <= get_second;
                
            when get_second =>
                cs1 <= '1';                     -- Activating matrix1
                oe1 <= '1';                     -- Enabling output of matrix 1
                ld_r3 <= '1';                   -- Loading into r3 <- matrix1[r1][c1];
                mux_inc <= "10";                -- Selected to increment r1
                mux_r1 <= "01";                 -- Loading into r1 the new incremented value
                next_state <= mac;
                
            when mac =>
                mux_sum <= "01";                -- sum <- sum + (r1 * r2). This is done in 64 bit
                
                next_state <= while_col2;
                if (end_r1 = '1') then
                    next_state <= store;
                end if;
                
            when store =>
                cs2 <= '1';                     -- Activating matrix2
                rw2 <= '0';                     -- Enabling writing into matrix2
                                                -- Matrix2[r0][c1] <- sum
                mux_inc <= "11";                -- Selected to increment c1
                mux_c1 <= "01";                 -- Loading into c1 the new incremented value
                
                next_state <= while_col2;
                
            when go_on =>
                mux_inc <= "00";                -- Selected to increment r0
                mux_r0 <= "01";                 -- Loading into r0 the new incremented value
    
            when done =>
                finish <= '1';
                next_state <= wait_comm;
            
            when others =>
                next_state <= wait_comm;
    
        end case;
    
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_comm;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;
    

end Behavioral;

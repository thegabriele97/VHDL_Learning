library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sequential_mult is
    port(
        clk, rst, start: in std_logic;
        a, b: in std_logic_vector(7 downto 0);
        res: out std_logic_vector(15 downto 0);
        ready: out std_logic
    );
end sequential_mult;

architecture hlsm of sequential_mult is

    type fsm_state is ( idle, check_ncalc, finish );
    signal curr_state, next_state: fsm_state;
    signal curr_a, next_a, curr_b, next_b: std_logic_vector(15 downto 0);
    signal curr_p, next_p: std_logic_vector(15 downto 0);

begin

    process(a, b, start, curr_state, curr_a, curr_b, curr_p)
    begin
    
        next_state <= curr_state;
        next_a <= curr_a;
        next_b <= curr_b;
        next_p <= curr_p;
        ready <= '0';
        
        case curr_state is
        
            when idle =>
                next_p <= (others => '0');
                next_a <= x"00" & a;
                next_b <= x"00" & b;
                
                if (start = '1') then
                    next_state <= check_ncalc;
                end if;
        
            when check_ncalc =>
                next_state <= finish;
                
                if (TO_INTEGER(unsigned(curr_b)) /= 0) then
                    if (curr_b(0) = '1') then
                        next_p <= std_logic_vector(unsigned(curr_p) + unsigned(curr_a));
                    end if;
                    
                    next_b <= '0' & curr_b(15 downto 1);
                    next_a <= curr_a(14 downto 0) & '0';
                    next_state <= check_ncalc;
                end if;

            when finish =>
                ready <= '1';
                next_state <= idle;
                
            when others =>
                next_state <= idle;
        
        end case;
    
    end process;
    
    res <= curr_p;

    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_a <= (others => '0');
                curr_b <= (others => '0');
                curr_p <= (others => '0');
                curr_state <= idle;
            else
                curr_a <= next_a;
                curr_b <= next_b;
                curr_p <= next_p;
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end hlsm;

architecture fsmd of sequential_mult is

    component fsmd_datapath is
        port(
            clk, rst: in std_logic;
            
            --Data input
            a, b: in std_logic_vector(7 downto 0);
            
            --Control & Status signals
            ld_a, ld_b, ld_p: in std_logic;
            shl_a, shr_b: in std_logic;
            en_p: in std_logic;
        
            tc_b, b0_1: out std_logic;
            
            --Data output
            p: out std_logic_vector(15 downto 0)
        );
    end component;

    component fsmd_controller is
        port(
            clk, rst, start: in std_logic;
            ready: out std_logic;
            
            --Control & Status signals
            ld_a, ld_b, ld_p: out std_logic;
            shl_a, shr_b: out std_logic;
            en_p: out std_logic;
        
            tc_b, b0_1: in std_logic
        );
    end component;
    
    signal ld_a, ld_b, ld_p, shl_a, shr_b, tc_b, en_p, b0_1: std_logic;

begin

    DP: fsmd_datapath port map(clk, rst, a, b, ld_a, ld_b, ld_p, shl_a, shr_b, en_p, tc_b, b0_1, res);
    CTRL: fsmd_controller port map(clk, rst, start, ready, ld_a, ld_b, ld_p, shl_a, shr_b, en_p, tc_b, b0_1);

end fsmd;

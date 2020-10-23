library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reconfigurable_alu is
    port(
        a, b: in std_logic_vector(15 downto 0);
        nibble: in std_logic_vector(3 downto 0);
        ctrl: in std_logic_vector(2 downto 0);
        result: out std_logic_vector(15 downto 0)
    );
end reconfigurable_alu;

architecture NoShift of reconfigurable_alu is

    component FullALU is
        generic(
            nbits: integer := 8
        );
        port(
            src1, src2: in std_logic_vector((nbits-1) downto 0);
            ctrl: in std_logic_vector(2 downto 0);
            c_in, enable: in std_logic;
            result: out std_logic_vector((nbits-1) downto 0);
            c_out: out std_logic
        );
    end component;
    
    component ripple_carry is
        port(
            c_in_curr, c_out_curr2next, enable_curr: in std_logic;
            c_out_curr, c_out_next: out std_logic
        );
    end component;
    
    component nibble_shift is
        port(
            nibble: in std_logic_vector(3 downto 0);
            d_in: in std_logic_vector(15 downto 0);
            d_out: out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal carry_in, carry_out, int_carr_out: std_logic_vector(4 downto 0);
    signal int_ctrl: std_logic_vector(2 downto 0);
    signal int_src2, int_res: std_logic_vector(15 downto 0);

begin
    
    carry_in(0) <= '0';
    
    process(ctrl, b)
        
        variable already_fixed: boolean := false;
        variable src: std_logic_vector(15 downto 0) := (others => '0');
    
    begin
    
        if (ctrl(2) = '0') then
            int_ctrl <= "100";
            
            for i in 0 to 3 loop
                if (not(already_fixed) and nibble(i) = '1') then
                    src(4*i) := '1';
                    already_fixed := true;
                end if;
            end loop;
            
            int_src2 <= src;
        else
            int_ctrl <= ctrl;
            int_src2 <= b;
        end if;
    
    end process;
    
    alus_gen: for i in 0 to 3 generate
        alu: FullALU generic map(nbits => 4) port map(
            src1 => a((i*4+3) downto (i*4)),
            src2 => int_src2((i*4+3) downto (i*4)),
            c_in => carry_out(i),
            c_out => int_carr_out(i),
            result => int_res((i*4+3) downto (i*4)),
            ctrl => int_ctrl,
            enable => nibble(i)
        );
    end generate;
    
    ripple_carry_gen: for i in 0 to 3 generate
        carry_ctrl: ripple_carry port map(
            c_in_curr => carry_in(i),
            c_out_curr2next => int_carr_out(i),
            enable_curr => nibble(i),
            c_out_curr => carry_out(i),
            c_out_next => carry_in(i+1)
        );
    end generate;
    
    nibble_shift_out: nibble_shift port map(
        nibble => nibble,
        d_in => int_res,
        d_out => result
    );
    
end NoShift;
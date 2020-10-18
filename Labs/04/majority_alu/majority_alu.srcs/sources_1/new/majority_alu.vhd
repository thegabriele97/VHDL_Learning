library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity majority_alu is
    generic(
        nbits: integer := 8
    );
    port(
        a, b, c, d, e, f: in std_logic_vector((nbits - 1) downto 0);
        ctrl: in std_logic_vector(2 downto 0);
        decision: out std_logic_vector((nbits - 1) downto 0);
        data_valid: out std_logic
    );
end majority_alu;

architecture Behavioral of majority_alu is

    component ALU is
        generic(
            nbit: integer := 8
        );
        port(
            src1, src2: in std_logic_vector((nbit-1) downto 0);
            ctrl: in std_logic_vector(2 downto 0);
            result: out std_logic_vector((nbit-1) downto 0)
        );
    end component;
    
    signal sum1, sum2, sum3: std_logic_vector((nbits - 1) downto 0);
    
begin

    alu_1: ALU generic map(nbits) port map(
        src1 => a,
        src2 => b,
        ctrl => ctrl,
        result => sum1
    );
    
    alu_2: ALU generic map(nbits) port map(
        src1 => c,
        src2 => d,
        ctrl => ctrl,
        result => sum2
    );
    
    alu_3: ALU generic map(nbits) port map(
        src1 => e,
        src2 => f,
        ctrl => ctrl,
        result => sum3
    );
    
    process(sum1, sum2, sum3)
    
        variable vs1, vs2, vs3: boolean;
    
    begin
    
        vs1 := (sum1 = sum2);
        vs2 := (sum1 = sum3);
        vs3 := (sum2 = sum3);
        
        if (vs1 and vs2 and vs3) then
            decision <= sum1;
            data_valid <= '1';
        elsif (vs1 or vs2) then
            decision <= sum1;
            data_valid <= '1';
        elsif (vs3) then
            decision <= sum2;
            data_valid <= '1';
        elsif (not(vs1) and not(vs2) and not(vs3)) then
            decision <= (others => 'Z');
            data_valid <= '0';
        end if;
    
    end process;
    
end Behavioral;

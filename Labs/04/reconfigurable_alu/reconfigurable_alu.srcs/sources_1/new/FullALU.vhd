library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity FullALU is
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
end FullALU;

architecture Behavioral of FullALU is

    component ALU_wcarry is
        generic(
            nbit: integer := 8
        );
        port(
            src1, src2: in std_logic_vector((nbit-1) downto 0);
            ctrl: in std_logic_vector(2 downto 0);
            result: out std_logic_vector((nbit-1) downto 0);
            c_out: out std_logic
        );
    end component;
    
    signal int_result: std_logic_vector(nbits downto 0);
    
begin

    internal_alu: ALU_wcarry generic map(nbit => nbits) port map(
        src1 => src1, 
        src2 => src2, 
        ctrl => ctrl, 
        result => int_result((nbits-1) downto 0), 
        c_out => int_result(nbits)
    );
    
    process(int_result, c_in, enable, ctrl)
    
        variable total: signed(nbits downto 0);
    
    begin
    
        if (enable = '1') then
            total := signed(int_result);
            
            if (ctrl(2) = '0' or ctrl = "100") then   
                total := total + ('0' & c_in);        -- carry in is added to the result only if the selected op is add1 or generic add
            elsif (ctrl = "101") then
                total := total - ('0' & c_in);        -- carry in is intead substracted if i want to do a substraction
            end if;
        else
            total := (others => '0');   -- all 0 pattern as output (c_out included) when not enabled
        end if;
    
        result <= std_logic_vector(total((nbits-1) downto 0));
        c_out <= total(nbits);
    
    end process;

end Behavioral;

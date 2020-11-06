library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter is
    port(
        clk, ld: in std_logic;
        ld_seed: in std_logic_vector(7 downto 0);
        reg: out std_logic_vector(7 downto 0)
    );
end counter;

architecture Behavioral of counter is

    signal int_reg: std_logic_vector(7 downto 0);

begin

    process(clk, ld)
        
        variable f, sh_in: std_logic;
    
    begin
    
        if (ld = '1') then
            int_reg <= ld_seed;
        elsif (rising_edge(clk)) then
        
            f := int_reg(4) xor int_reg(3) xor int_reg(2) xor int_reg(0);
            
            if (int_reg(7 downto 1) /= "0000000") then
                sh_in := f;
            else 
                sh_in := f xor '1';
            end if;
            
            int_reg <= sh_in & int_reg(7 downto 1); 
        
        end if;
    
    end process;
    
    reg <= int_reg;

end Behavioral;

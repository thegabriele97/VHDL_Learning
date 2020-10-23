library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multifcn_reg is
    generic(
        nbits: integer := 4
    );
    port(
        d_in: in std_logic_vector((nbits-1) downto 0);
        sh_in, clk: in std_logic; 
        op: in std_logic_vector(1 downto 0);
        d_out: out std_logic_vector((nbits-1) downto 0)
    );
end multifcn_reg;

architecture Behavioral of multifcn_reg is

    signal int_data: std_logic_vector((nbits-1) downto 0);

begin

    process(clk, d_in, sh_in, op)
    begin
    
        if (rising_edge(clk)) then
            if (op /= "00") then
            
                case op is
                    when "01" =>
                        int_data <= d_in;
                    
                    when "10" =>
                        for i in 0 to (nbits-2) loop
                            int_data(i) <= int_data(i+1);
                        end loop;
                        
                        int_data(nbits-1) <= sh_in;
                     
                    when others =>
                        int_data <= (others => '0');
                        
                 end case;
            
            end if;            
        end if;
    
    end process;
    
    d_out <= int_data;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shl_reg is
    generic (
        nbits: integer := 4
    );    
    port(
        d_in, sh_enable, clk, rst: in std_logic;
        d_out: out std_logic_vector((nbits-1) downto 0)
    );
end shl_reg;

architecture Behavioral of shl_reg is

    signal int_data: std_logic_vector((nbits-1) downto 0);

begin
    
    process(clk, d_in, sh_enable, rst)
    begin
    
        if (rst = '1') then
            int_data <= (others => '0');
        elsif (rising_edge(clk)) then
            if (sh_enable = '1') then
                
                for i in 0 to (nbits-2) loop
                    int_data(i) <= int_data(i+1);
                end loop;
                
                int_data(nbits-1) <= d_in;
                
            end if;
        end if;
    
    end process;

    d_out <= int_data;

end Behavioral;

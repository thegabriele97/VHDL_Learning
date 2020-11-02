library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter is
    generic(
        nbits: integer := 4
    );
    port(
        clk, enable, rst: in std_logic;
        r_reg: out std_logic_vector((nbits-1) downto 0)
    );
end counter;

architecture Behavioral of counter is

    signal curr_state, next_state: std_logic_vector((nbits-1) downto 0);

begin

    process(clk, rst, enable)
    begin
        
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state((nbits-1) downto 1) <= (others => '0');   
                curr_state(0) <= '1';
            elsif (enable = '1') then
                curr_state <= next_state;
            end if;
        end if;
        
    end process;
    
    next_state((nbits-2) downto 0) <= curr_state((nbits-1) downto 1);
    next_state((nbits-1)) <= curr_state(0);
    
    r_reg <= curr_state;

end Behavioral;

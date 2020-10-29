library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dec_counter is
    generic(
        ndigits: integer := 3
    );
    port(
        clk, enable, rst: in std_logic;
        end_cnt: out std_logic;
        cnt: out std_logic_vector((4*ndigits-1) downto 0)
    );
end dec_counter;

architecture Behavioral of dec_counter is
    
    component dec_count_1digit is
        port(
            clk, enable, rst: in std_logic;
            last_cnt: out std_logic;
            cnt: out std_logic_vector(3 downto 0)    
        );
    end component;
  
    signal stage_activate: std_logic_vector((ndigits-1) downto 0);
            
begin

    stage_gen: for i in 0 to (ndigits-1) generate
        
        less_gen: if (i = 0) generate
            digit_i: dec_count_1digit port map(
                clk => clk,
                enable => enable,
                rst => rst,
                cnt => cnt((3+i*4) downto (i*4)),
                last_cnt => stage_activate(i)
            );
        end generate;
        
        others_gen: if (i > 0 and i <= (ndigits-1)) generate
            digit_i: dec_count_1digit port map(
                clk => clk,
                enable => stage_activate(i-1),
                rst => rst,
                cnt => cnt((3+i*4) downto (i*4)),
                last_cnt => stage_activate(i)
            );
        end generate;
        
    end generate;
    
    end_cnt <= stage_activate(ndigits-1);

end Behavioral;

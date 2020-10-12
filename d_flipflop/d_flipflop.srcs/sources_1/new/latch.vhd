library ieee;
use ieee.std_logic_1164.all;

entity latch is
    port(
        q: inout std_logic;
        q_c: inout std_logic
    );
end latch;

architecture latch_arch of latch is
    
    signal q_mem: std_logic;

begin
    
    process(q, q_c)
    begin
        
        q_mem <= q;

    end process;
    
    process(q_mem)
    begin
    
        q <= q_mem;
        q_c <= not(q_mem);
    
    end process;

end latch_arch;

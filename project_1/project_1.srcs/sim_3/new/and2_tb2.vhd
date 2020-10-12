library ieee;
use ieee.std_logic_1164.all;

entity AND2_TB is
end AND2_TB;

architecture AND2_TB_ARCH of AND2_TB is
    component AND2 is
        port (
            X, Y: in std_logic;
            O:    out std_logic
        );
    end component;
    
    signal X_S, Y_S, O_S: std_logic;

begin
    and2_test: AND2 PORT MAP(X_S, Y_S, O_S);
    
    process
    begin
        X_S <= '0';
        y_S <= '0';
        wait for 10 ns;
    
        X_S <= '0';
        y_S <= '1';
        wait for 10 ns;
        
        X_S <= '1';
        y_S <= '0';
        wait for 10 ns;
        
        X_S <= '1';
        y_S <= '1';
        wait;
    end process;

end AND2_TB_ARCH;
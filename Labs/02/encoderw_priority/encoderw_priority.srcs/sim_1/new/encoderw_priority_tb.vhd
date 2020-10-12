library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoderw_priority_tb is
end encoderw_priority_tb;

architecture Behavioral of encoderw_priority_tb is

    component encoderw_priority is
        port(
            req: in std_logic_vector(3 downto 0);
            code: out std_logic_vector(1 downto 0);
            active: out std_logic
        );
    end component;

    for encoder_test: encoderw_priority use entity work.encoderw_priority(Behav_Case);

    signal req_s: std_logic_vector(3 downto 0);
    signal code_s: std_logic_vector(1 downto 0);
    signal active_s: std_logic;
    
begin

    encoder_test: encoderw_priority port map(req_s, code_s, active_s);
    
    process
    begin
    
        req_s <= "UUUU";
        wait for 10 ns;
    
        req_s <= "0000";
        wait for 10 ns;
        
        req_s <= "0001";
        wait for 10 ns;
        
        req_s <= "0010";
        wait for 10 ns;
        
        req_s <= "0100";
        wait for 10 ns;
        
        req_s <= "1000";
        wait for 10 ns;
        
        req_s <= "1111";
        wait for 10 ns;
        
        req_s <= "1011";
        wait for 10 ns;
        
        req_s <= "1001";
        wait for 10 ns;
        
        req_s <= "1010";
        wait for 10 ns;
        
        req_s <= "0101";
        wait for 10 ns;
    
    end process;

end Behavioral;

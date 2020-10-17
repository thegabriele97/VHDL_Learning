library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_coll is
end tb_coll;

architecture Behavioral of tb_coll is

    component coll_detect is
        port(
            m: in std_logic_vector(3 downto 0);
            c: out std_logic
        );
    end component;

    for test: work.coll_Detect(Behav_When);

    signal m_s: std_logic_vector(3 downto 0);
    signal c_s: std_logic;

begin

    test: coll_detect port map(m_s, c_s);
    
    process
    begin
    
        m_s <= "0000";
        wait for 10 ns;
        
        m_s <= "0001";
        wait for 10 ns;
        
        m_s <= "0010";
        wait for 10 ns;
        
        m_s <= "0100";
        wait for 10 ns;
    
        m_s <= "1000";
        wait for 10 ns;
        
        m_s <= "0101";
        wait for 10 ns;
    
        m_s <= "1011";
        wait for 10 ns;
        
        m_s <= "0111";
        wait for 10 ns;
        
        m_s <= "1111";
        wait for 10 ns;
        
    end process;
    
    
end Behavioral;

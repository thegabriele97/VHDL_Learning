library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Seq_Rec_tb is
end Seq_Rec_tb;

architecture Behavioral of Seq_Rec_tb is

    component Seq_Rec is
        port(
            clk, rst, en, x: in std_logic;
            z: out std_logic_vector(1 downto 0)
        );
    end component;

    signal clk, rst, en, x: std_logic := '0';
    signal z1, z0: std_logic;

    type arr is array (0 to 17) of std_logic;

begin
    
    DUT: Seq_Rec port map(clk => clk, rst => rst, en => en, x => x, z(1) => z1, z(0) => z0);

    process
    begin
    
        wait for 0.5 ns;
        clk <= not clk;
    
    end process;

    process
    
        variable en_a: arr := ('0', '0', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0');
        variable x_a: arr := ('0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '1', '0', '0', '1', '1', '1', '1', '1');
    
    begin
    
        rst <= '1';
        wait for 1 ns;
        
        rst <= '0';
        wait for  1 ns;
        
        for i in en_a'range loop
        
            en <= en_a(i);
            x <= x_a(i);
            wait for 1 ns;
        
        end loop;
        
        en <= '0';
        wait;
    
    end process;

end Behavioral;

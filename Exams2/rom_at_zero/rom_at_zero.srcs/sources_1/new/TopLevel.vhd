library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
    port(
        clk, rst, go: in std_logic;
        counter: out std_logic_vector(3 downto 0);
        finish: out std_logic
    );
end TopLevel;

architecture Behavioral of TopLevel is

    component controller is
        port(
            clk, rst, go: in std_logic;
            addr: out std_logic_vector(2 downto 0);
            data: in std_logic_vector(3 downto 0);
            counter: out std_logic_vector(3 downto 0);
            finish: out std_logic
        );
    end component;

    component rom is
        port(
            oe: in std_logic;
            addr: in std_logic_vector((3-1) downto 0);
            data: out std_logic_vector((4-1) downto 0)
        );
    end component;

    signal addr: std_logic_vector(2 downto 0);
    signal data: std_logic_vector(3 downto 0);
    
begin

    ROM0: rom port map('1', addr, data);
    Ctrl0: controller port map(clk, rst, go, addr, data, counter, finish);

end Behavioral;

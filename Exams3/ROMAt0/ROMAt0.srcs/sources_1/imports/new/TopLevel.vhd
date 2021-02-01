library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
    port(
        clk, rst, go: in std_logic;
        finish: out std_logic;
        cnt: out std_logic_vector(3 downto 0)
    );
end TopLevel;

architecture Behavioral of TopLevel is

    component rom is
        port(
            oe: in std_logic;
            addr: in std_logic_vector((3-1) downto 0);
            data: out std_logic_vector((4-1) downto 0)
        );
    end component;

    component Controller is
        port(
            clk, rst, go: in std_logic;
            data: in std_logic_vector(3 downto 0);
            finish: out std_logic;
            cnt: out std_logic_vector(3 downto 0);
            addr: out std_logic_vector(2 downto 0)
        );
    end component;

    signal addr: std_logic_vector(2 downto 0);
    signal data, counter: std_logic_vector(3 downto 0); 

begin

    ROM1: rom port map('1', addr, data);
    CTRL: Controller port map(clk, rst, go, data, finish, counter, addr);
    
    cnt <= counter;
    
end Behavioral;

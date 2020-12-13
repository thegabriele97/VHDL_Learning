library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    port(
        clk, rst, go: in std_logic;
        DataIn: in std_logic_vector(3 downto 0);
        finish: out std_logic;
        cnt: out std_logic_vector(3 downto 0)
    );
end toplevel;

architecture struct of toplevel is

    component mem_comparator is
        port(
            clk, rst, go: in std_logic;
            DataIn: in std_logic_vector(3 downto 0);
            finish: out std_logic;
            cnt: out std_logic_vector(3 downto 0);
            
            addr: out std_logic_vector(2 downto 0);
            data: in std_logic_vector(3 downto 0)
        );
    end component;

    component rom is
        port(
            a: in std_logic_vector(2 downto 0);
            d: out std_logic_vector(3 downto 0)
        );
    end component;

    signal addr: std_logic_vector(2 downto 0);
    signal data: std_logic_vector(3 downto 0);

begin

    rom0: rom port map(addr, data);
    ctrl: mem_comparator port map(clk, rst, go, DataIn, finish, cnt, addr, data);

end struct;

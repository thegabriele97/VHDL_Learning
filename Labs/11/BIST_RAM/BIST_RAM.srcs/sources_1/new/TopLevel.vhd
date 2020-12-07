library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
    port(
        clk, rst, go: in std_logic;
        finish, error: out std_logic
    );
end TopLevel;

architecture Behavioral of TopLevel is

    component BIST is
        port(
            clk, rst, go: in std_logic;
            data_i: in std_logic_vector(5 downto 0);
            finish, error, we: out std_logic;
            addr: out std_logic_vector(15 downto 0);
            data_o: out std_logic_vector(5 downto 0)
        );
    end component;

    component RAM is
        generic(
            k, n: integer
        );
        port(
            clk, rst, rw: in std_logic;
            a: in std_logic_vector((k-1) downto 0);
            x: in std_logic_vector((n-1) downto 0);
            z: out std_logic_vector((n-1) downto 0)
        );
    end component;

    signal we: std_logic;
    signal addr: std_logic_vector(15 downto 0);
    signal data_o, data_i: std_logic_vector(5 downto 0);

begin

    RAM1: RAM generic map(16, 6) port map(clk, '0', we, addr, data_o, data_i);
    BIST1: BIST port map(clk, rst, go, data_i, finish, error, we, addr, data_o);

end Behavioral;

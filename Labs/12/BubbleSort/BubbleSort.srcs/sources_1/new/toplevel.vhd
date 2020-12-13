library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    port(
        clk, rst, go: in std_logic;
        finish, error: out std_logic
    );
end toplevel;

architecture Behavioral of toplevel is
    
    component RAM is
        generic(
            k: integer := 3;
            n: integer := 4
        );
        port(
            clk, rst, rw: in std_logic;
            a: in std_logic_vector((k-1) downto 0);
            x: in std_logic_vector((n-1) downto 0);
            z: out std_logic_vector((n-1) downto 0)
        );
    end component;
    
    component sorting_unit is
        port(
            clk, rst, go: in std_logic;
            finish, rw, error: out std_logic;
            
            addr: out std_logic_vector(2 downto 0);
            din: in std_logic_vector(3 downto 0);
            dout: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal addr: std_logic_vector(2 downto 0);
    signal din, dout: std_logic_vector(3 downto 0);
    signal rw: std_logic;
    
begin

    ram0: RAM port map(clk, rst, rw, addr, dout, din);
    soun: sorting_unit port map(clk, rst, go, finish, rw, error, addr, din, dout);

end Behavioral;

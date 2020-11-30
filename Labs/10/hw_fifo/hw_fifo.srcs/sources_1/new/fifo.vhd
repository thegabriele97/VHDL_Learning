library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fifo is
    generic (
        m: integer := 4;
        n: integer := 8
    );
    port (
        clk, rst, wr, rd: in std_logic;
        full, empty: out std_logic;
        r_data: out std_logic_vector((n-1) downto 0);
        w_data: in std_logic_vector((n-1) downto 0)
    );
end fifo;

architecture structural of fifo is

    component reg_file is
        generic (
            m: integer := 4;
            n: integer := 8
        );
        port (
            clk, rst, w_en: in std_logic;
            w_addr, r_addr: in std_logic_vector((m-1) downto 0);
            r_data: out std_logic_vector((n-1) downto 0);
            w_data: in std_logic_vector((n-1) downto 0)
        );
    end component;
    
    component controller is
        generic (
            m: integer := 4
        );
        port(
            clk, rst, wr, rd: in std_logic;
            full, empty, w_en: out std_logic;
            w_addr, r_addr: out std_logic_vector((m-1) downto 0)
        );
    end component;
    
    signal w_en: std_logic;
    signal int_w_addr, int_r_addr: std_logic_vector((m-1) downto 0);
    
begin

    regs: reg_file generic map(m, n) port map(clk, rst, w_en, int_w_addr, int_r_addr, r_data, w_data);
    ctrl: controller generic map(m) port map(clk, rst, wr, rd, full, empty, w_en, int_w_addr, int_r_addr);

end structural;


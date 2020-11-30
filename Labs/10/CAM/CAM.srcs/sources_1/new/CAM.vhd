library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CAM is
    generic(
        m: integer := 2;
        p: integer := 16;
        n: integer := 3
    );
    port(
        clk, rst, wr_en: in std_logic;
        key_in: in std_logic_vector((p-1) downto 0);
        hit: out std_logic;
        w_data: in std_logic_vector((n-1) downto 0);
        data: out std_logic_vector((n-1) downto 0)
    );
end CAM;

architecture struct of CAM is

    component RegFileGen is
        generic(
            m, n: integer
        );
        port(
            clk, rst, w_en: in std_logic;
            w_addr, r_addr: in std_logic_vector((m-1) downto 0);
            w_data: in std_logic_vector((n-1) downto 0);
            r_data: out std_logic_vector((n-1) downto 0)
        );
    end component;

    component KeyFile is
        generic(
            m, n: integer
        );
        port(
            clk, rst: in std_logic;
            key_in: in std_logic_vector((n-1) downto 0);
            ld: in std_logic_vector((2**m-1) downto 0);
            addr: out std_logic_vector((m-1) downto 0);
            hit: out std_logic
        );
    end component;

    component ReplPtr is
        generic(
            m: integer
        );
        port(
            clk, rst, en_replptr: in std_logic;
            wr_wordline: out std_logic_vector((2**m-1) downto 0)
        );
    end component;
    
    component Controller is
        port(
            clk, rst, hit, rw: in std_logic;
            wr_en, en_replptr: out std_logic
        );
    end component;

    signal w_en, n_wr_en, int_hit, en_rp: std_logic;
    signal addr: std_logic_vector((m-1) downto 0);
    signal wr_wordline: std_logic_vector((2**m-1) downto 0);

begin

    RegFile: RegFileGen generic map(m, n) port map(clk, rst, w_en, addr, addr, w_data, data);
    KF: KeyFile generic map(m, p) port map(clk, rst, key_in, wr_wordline, addr, int_hit);
    RepPtr: ReplPtr generic map(m) port map(clk, rst, en_rp, wr_wordline); 
    
    n_wr_en <= not wr_en;
    hit <= int_hit;
    
    Ctrl: Controller port map(clk, rst, int_hit, n_wr_en, w_en, en_rp);

end struct;

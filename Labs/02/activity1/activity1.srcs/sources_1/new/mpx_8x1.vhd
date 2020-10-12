library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mpx_8x1 is
    port(
        d: in std_logic_vector(7 downto 0);
        s: in std_logic_vector(2 downto 0);
        y: out std_logic
    );
end mpx_8x1;

architecture struct of mpx_8x1 is

    component mpx_4x1 is
        port(
            d: in std_logic_vector(3 downto 0);
            s: in std_logic_vector(1 downto 0);
            y: out std_logic
        );
    end component;
    
    component mpx_2x1 is
        port(
            d: in std_logic_vector(1 downto 0);
            s: in std_logic;
            y: out std_logic
        );
    end component;
    
    signal y1, y2: std_logic;
    
begin

    mpx4_1: mpx_4x1 port map(d(3 downto 0), s(1 downto 0), y1);
    mpx4_2: mpx_4x1 port map(d(7 downto 4), s(1 downto 0), y2);
    mpx2_1: mpx_2x1 port map(
        d(0) => y1,
        d(1) => y2,
        s => s(2),
        y => y
    );

end struct;

architecture Behav_Case of mpx_8x1 is
begin
    
    process(d, s)
    begin
    
        case s is
            when "000" =>
                y <= d(0);
            when "001" =>
                y <= d(1);
            when "010" =>
                y <= d(2);
            when "011" =>
                y <= d(3);
            when "100" =>
                y <= d(4);
            when "101" =>
                y <= d(5);
            when "110" =>
                y <= d(6);
            when "111" =>
                y <= d(7);
            when others =>
                y <= 'X';
        end case;
    
    end process;

end Behav_Case;

architecture Behav_IfThenElse of mpx_8x1 is
begin

    process(d, s)
    begin
    
        if s = "000" then
            y <= d(0);
        elsif s = "001" then
            y <= d(1);
        elsif s = "010" then
            y <= d(2);
        elsif s = "011" then
            y <= d(3);
        elsif s = "100" then
            y <= d(4);
        elsif s = "101" then
            y <= d(5);
        elsif s = "110" then
            y <= d(6);
        elsif s = "111" then
            y <= d(7);
        end if;
    
    end process;

end Behav_IfThenElse;

architecture DataFlow_WhenElse of mpx_8x1 is
begin

    y <= d(0) when s = "000" else
         d(1) when s = "001" else
         d(2) when s = "010" else
         d(3) when s = "011" else
         d(4) when s = "100" else
         d(5) when s = "101" else
         d(6) when s = "110" else
         d(7) when s = "111";

end DataFlow_WhenElse;

architecture DataFlow_WithSelectWhen of mpx_8x1 is
begin

    with s select
        y <= d(0) when "000",
             d(1) when "001",
             d(2) when "010",
             d(3) when "011",
             d(4) when "100",
             d(5) when "101",
             d(6) when "110",
             d(7) when "111",
             'X' when others;

end DataFlow_WithSelectWhen;

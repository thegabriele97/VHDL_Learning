library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_1s is
    port(
        d: in std_logic_vector(7 downto 0);
        s: inout std_logic_vector(3 downto 0)
    );
end counter_1s;

architecture counter_1s_arch_v2 of counter_1s is

    component counter_1s_2bit is
        port(
            d: in std_logic_vector(1 downto 0);
            o: out std_logic_vector(1 downto 0)
        );
    end component;
    
    component adder_2bit is
        port(
            a: in std_logic_vector(1 downto 0);
            b: in std_logic_vector(1 downto 0);
            o: out std_logic_vector(1 downto 0);
            c_out: out std_logic
        );
    end component;
    
    component adder_4bit is
        port(
            a: in std_logic_vector(3 downto 0);
            b: in std_logic_vector(3 downto 0);
            c_in: in std_logic;
            o: out std_logic_vector(3 downto 0);
            c_out: out std_logic
        );
    end component;
    
    signal part_cnt, part_cnt2:  std_logic_vector(7 downto 0) := "00000000";
    signal c_out: std_logic;

begin
    
    counter_1: counter_1s_2bit port map(d(1 downto 0), part_cnt(1 downto 0));
    counter_2: counter_1s_2bit port map(d(3 downto 2), part_cnt(3 downto 2));
    counter_3: counter_1s_2bit port map(d(5 downto 4), part_cnt(5 downto 4));
    counter_4: counter_1s_2bit port map(d(7 downto 6), part_cnt(7 downto 6));
    
    adder_2bit_1: adder_2bit port map(part_cnt(1 downto 0), part_cnt(3 downto 2), part_cnt2(1 downto 0), part_cnt2(2));
    adder_2bit_2: adder_2bit port map(part_cnt(5 downto 4), part_cnt(7 downto 6), part_cnt2(5 downto 4), part_cnt2(6));
    
    adder_4bit_1: adder_4bit port map(part_cnt2(3 downto 0), part_cnt2(7 downto 4), '0', s, c_out);

end counter_1s_arch_v2;

--architecture counter_1s_arch of counter_1s is

--    component adder_4bit is
--        port(
--            a: in std_logic_vector(3 downto 0);
--            b: in std_logic_vector(3 downto 0);
--            c_in: in std_logic;
--            o: out std_logic_vector(3 downto 0);
--            c_out: out std_logic
--        );
--    end component;
    
--    component half_adder is
--        port(
--            i: in std_logic_vector(1 downto 0);
--            o, c: out std_logic
--        );
--    end component;
    
--    signal partial_s, partial_s2, partial_s3, partial_s4, partial_s5, partial_s6: std_logic_vector(3 downto 0) := "0000";
--    signal partial_carry: std_logic_vector(8 downto 0);

--begin

--    adder_1: half_adder port map(d(1 downto 0), partial_s(0), partial_s(1));
--    adder_2: adder_4bit port map(
--        a => partial_s,
--        b(3 downto 1) => "000",
--        b(0) => d(2),
--        c_in => '0',
--        o => partial_s2,
--        c_out => partial_carry(0)
--    );
    
--    adder_3: adder_4bit port map(
--        a => partial_s2,
--        b(3 downto 1) => "000",
--        b(0) => d(3),
--        c_in => partial_carry(0),
--        o => partial_s3,
--        c_out => partial_carry(1)
--    );
    
--    adder_4: adder_4bit port map(
--        a => partial_s3,
--        b(3 downto 1) => "000",
--        b(0) => d(4),
--        c_in => partial_carry(1),
--        o => partial_s4,
--        c_out => partial_carry(2)
--    );
    
--    adder_5: adder_4bit port map(
--        a => partial_s4,
--        b(3 downto 1) => "000",
--        b(0) => d(5),
--        c_in => partial_carry(2),
--        o => partial_s5,
--        c_out => partial_carry(3)
--    );
    
--    adder_6: adder_4bit port map(
--        a => partial_s5,
--        b(3 downto 1) => "000",
--        b(0) => d(6),
--        c_in => partial_carry(3),
--        o => partial_s6,
--        c_out => partial_carry(4)
--    );
    
--    adder_7: adder_4bit port map(
--        a => partial_s6,
--        b(3 downto 1) => "000",
--        b(0) => d(7),
--        c_in => partial_carry(4),
--        o => s,
--        c_out => partial_carry(5)
--    );   
    

--end counter_1s_arch;

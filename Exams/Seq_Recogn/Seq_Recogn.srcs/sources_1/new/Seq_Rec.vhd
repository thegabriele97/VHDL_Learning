library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Seq_Rec is
    port(
        clk, rst, en, x: in std_logic;
        z: out std_logic_vector(1 downto 0)
    );
end Seq_Rec;

architecture Behavioral of Seq_Rec is

    type fsm_state is ( wait_en, a, b, c, d, e );
    signal curr_state, next_state: fsm_state;

begin
    
    process(curr_state, en, x)
    begin
    
        next_state <= curr_state;
        z <= "00";
        
        case curr_state is
        
            when wait_en =>
                if (en = '1') then
                    if (x = '1') then
                        next_state <= a;
                    elsif (x = '0') then
                        next_state <= d;
                    end if;
                end if;
        
            when a =>
                if (en = '0') then
                    next_state <= wait_en;
                elsif (en = '1') then
                    if (x = '1') then
                        next_state <= b;
                    elsif (x = '0') then
                        next_state <= d;
                    end if;
                end if;
                
            when b =>
                if (en = '0') then
                    next_state <= wait_en;
                elsif (en = '1') then
                    if (x = '1') then
                        next_state <= c;
                        --z <= "10";
                    elsif (x = '0') then
                        next_state <= d;
                    end if;
                end if;
                
            when c =>
                if (en = '0') then
                    next_state <= wait_en;
                elsif (en = '1') then
                    if (x = '1') then
                        next_state <= c;
                        z <= "10";
                    elsif (x = '0') then
                        next_state <= d;
                    end if;
                end if;
                
            when d =>
                if (en = '0') then
                    next_state <= wait_en;
                elsif (en = '1') then
                    if (x = '0') then
                        next_state <= e;
                        --z <= "01";
                    elsif (x = '1') then
                        next_state <= a;
                    end if;
                end if;
                
            when e =>
                if (en = '0') then
                    next_state <= wait_en;
                elsif (en = '1') then
                    if (x = '0') then
                        next_state <= e;
                        z <= "01";
                    elsif (x = '1') then
                        next_state <= a;
                    end if;
                end if;
                
            when others =>
                next_state <= wait_en;
        
        end case;
    
    end process;
    
    process(clk)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= wait_en;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end Behavioral;

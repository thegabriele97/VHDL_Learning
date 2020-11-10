library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity arbiter is
    port(
        clk, rst: in std_logic;
        req: in std_logic_vector(1 downto 0);
        grant: out std_logic_vector(1 downto 0)
    );
end arbiter;

architecture Moore_DynamicPriority of arbiter is

    type fsm_state is ( init, wait_req, req_grant1, req_grant2 );
    signal curr_state, next_state: fsm_state;
    signal curr_last_grant, next_last_grant: std_logic;

begin

    process(curr_state, curr_last_grant, req)
    begin
    
        grant <= "00";
        next_state <= curr_state;
        next_last_grant <= curr_last_grant;
    
        case curr_state is
        
            when init =>
                next_last_grant <= '1';
                next_state <= wait_req;
        
            when wait_req =>
                
                if ((req = "11" and curr_last_grant = '1') or req = "01" ) then
                    next_state <= req_grant1;
                elsif ((req = "11" and curr_last_grant = '0') or req = "10" ) then
                    next_state <= req_grant2;
                end if;
                
            when req_grant1 =>
                grant(0) <= '1';
                
                next_last_grant <= '0';
                if (req(0) = '0') then
                    next_state <= wait_req;
                end if;
                
            when req_grant2 =>
                grant(1) <= '1';
                
                next_last_grant <= '1';
                if (req(1) = '0') then
                    next_state <= wait_req;
                end if;
        
            when others =>
                next_state <= init;
        
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init;
                curr_last_grant <= '1';
            else
                curr_state <= next_statE;
                curr_last_grant <= next_last_grant;
            end if;
        end if;
    
    end process;

end Moore_DynamicPriority;

architecture Moore_FixPriority of arbiter is

    type fsm_state is ( init, wait_req, req_grant1, req_grant2 );
    signal curr_state, next_state: fsm_state;

begin

    process(curr_state, req)
    begin
    
        next_state <= curr_state;
        grant <= "00";
        
        case curr_state is
        
            when init =>
                next_state <= wait_req;
        
            when wait_req =>
                grant <= "00";
                
                if (req(0) = '1') then
                    next_state <= req_grant1;
                elsif (req(1) = '1') then
                    next_state <= req_grant2;
                end if;
                
            when req_grant1 =>
                grant(0) <= '1';
                
                if (req(0) = '0') then
                    if (req(1) = '1') then
                        next_state <= req_grant2;
                    else
                        next_state <= wait_req;
                    end if;
                end if;
                
            when req_grant2 =>
                grant(1) <= '1';
                
                if (req(1) = '0') then
                    if (req(0) = '1') then
                        next_state <= req_grant1;
                    else
                        next_state <= wait_req;
                    end if;
                end if;
                
            when others =>
                next_state <= init;
                
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rising_edge(clk)) then
            if (rst = '1') then
                curr_state <= init;
            else
                curr_state <= next_state;
            end if;
        end if;
    
    end process;

end Moore_FixPriority;

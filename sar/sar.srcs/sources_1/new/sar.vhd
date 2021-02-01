library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SAR is
	generic(
		nbits			: integer := 2;
		reg_siz		: integer := 2
	);
	
	port(
		clk			: in std_logic;
		rst			: in std_logic;
		
		--Start of conversion
		soc			: in std_logic;
		
		--End of conversion
		eoc			: out std_logic;
		
		--Comparator input
		comp_in		: in std_logic;
		
		--Data output: last conversion
		data			: out std_logic_vector((nbits-1) downto 0);
		
		--Data output: to DAC
		DAC_data		: out std_logic_vector((nbits-1) downto 0)
		
	);
end entity;

architecture hlsm of SAR is

	type fsm_state is ( wait_soc, try_1, confirm_bit, done );
	signal curr_state, next_state: fsm_state;
	
	signal curr_iter, next_iter: std_logic_vector((reg_siz - 1) downto 0);
	signal curr_dac, next_dac, curr_conv, next_conv: std_logic_vector((nbits-1) downto 0);
	
begin

	DAC_data <= curr_dac;
	data <= curr_conv;

	process(curr_state, curr_iter, curr_dac, curr_conv, soc, comp_in)
	begin
	
		next_state <= curr_state;
		next_iter <= curr_iter;
		next_dac <= curr_dac;
		next_conv <= curr_conv;
		eoc <= '0';
		
		case curr_state is
		
			when wait_soc =>
				next_iter <= std_logic_vector(TO_UNSIGNED(nbits-1, next_iter'length));
				next_dac <= (others => '0');
				
				if (soc = '1') then
					next_state <= try_1;
				end if;
				
			when try_1 =>
				next_dac(TO_INTEGER(unsigned(curr_iter))) <= '1';
				next_state <= confirm_bit;
				
			when confirm_bit =>
				next_dac(TO_INTEGER(unsigned(curr_iter))) <= comp_in;
				next_iter <= std_logic_vector(unsigned(curr_iter) - 1);
				
				if (unsigned(curr_iter) > 0) then
					next_state <= try_1;
				elsif (unsigned(curr_iter) = 0) then
					next_state <= done;
				end if;
				
			when done =>
				next_conv <= curr_dac;
				eoc <= '1';
				next_state <= wait_soc;
		
		end case;
	
	end process;

	process(clk, rst)
	begin
	
		if (rst = '1') then
			curr_state <= wait_soc;
			curr_dac <= (others => '0');
			curr_conv <= (others => '0');
			curr_iter <= (others => '0');
		elsif (rising_edge(clk)) then
			curr_state <= next_state;
			curr_dac <= next_dac;
			curr_iter <= next_iter;
			curr_conv <= next_conv;
		end if;
	
	end process;
	

end hlsm;

architecture hlsm2 of SAR is

	type fsm_state is ( wait_soc, try_1, confirm_bit, update_reg, done );
	signal curr_state, next_state: fsm_state;
	
	signal curr_iter, next_iter: std_logic_vector((reg_siz - 1) downto 0);
	signal curr_dac, next_dac, curr_conv, next_conv: std_logic_vector((nbits-1) downto 0);
	
begin

	DAC_data <= curr_dac;
	data <= curr_conv;

	process(curr_state, curr_iter, curr_dac, curr_conv, soc, comp_in)
	begin
	
		next_state <= curr_state;
		next_iter <= curr_iter;
		next_dac <= curr_dac;
		next_conv <= curr_conv;
		eoc <= '0';
		
		case curr_state is
		
			when wait_soc =>
				next_iter <= std_logic_vector(TO_UNSIGNED(nbits-1, next_iter'length));
				next_dac <= (others => '0');
				
				if (soc = '1') then
					next_state <= try_1;
				end if;
				
			when try_1 =>
				next_dac(TO_INTEGER(unsigned(curr_iter))) <= '1';
				next_state <= confirm_bit;
				
			when confirm_bit =>
				next_dac(TO_INTEGER(unsigned(curr_iter))) <= comp_in;
				next_iter <= std_logic_vector(unsigned(curr_iter) - 1);
				
				if (unsigned(curr_iter) > 0) then
					next_state <= try_1;
				elsif (unsigned(curr_iter) = 0) then
					next_state <= update_reg;
				end if;
			
			when update_reg =>
				next_conv <= curr_dac;
				next_state <= done;
			
			when done =>
				eoc <= '1';
				next_state <= wait_soc;
		
		end case;
	
	end process;

	process(clk, rst)
	begin
	
		if (rst = '1') then
			curr_state <= wait_soc;
			curr_dac <= (others => '0');
			curr_conv <= (others => '0');
			curr_iter <= (others => '0');
		elsif (rising_edge(clk)) then
			curr_state <= next_state;
			curr_dac <= next_dac;
			curr_iter <= next_iter;
			curr_conv <= next_conv;
		end if;
	
	end process;
	

end hlsm2;

architecture fsmd of SAR is

    -- Datapath signals
    signal curr_iter, next_iter: std_logic_vector((reg_siz - 1) downto 0);
    signal curr_conv, next_conv: std_logic_vector((nbits-1) downto 0);
    signal curr_dac, next_dac: std_logic_vector((nbits) downto 0);

    -- Controller signals
    type fsm_state is ( wait_soc, try_1, confirm_bit, update_reg, done );
    signal curr_state, next_state: fsm_state;

    -- Control signals
    signal mux_iter, mux_dac: std_logic_vector(1 downto 0);
    signal bit_in, ld_conv, stop: std_logic;

begin

    DAC_data <= curr_dac((nbits-1) downto 0);
    data <= curr_conv;

    -- Datapath description
    process(curr_iter, curr_dac, curr_conv, mux_iter, mux_dac, bit_in, ld_conv)
    begin
    
        -- ITER Register
        next_iter <= curr_iter;
        if (mux_iter = "01") then
            next_iter <= std_logic_vector(unsigned(curr_iter) - 1);
        elsif (mux_iter = "10") then
            next_iter <= std_logic_vector(TO_UNSIGNED(nbits-1, next_iter'length));
        end if;
    
        -- DAC Register
        next_dac <= curr_dac;
        if (mux_dac = "01") then
            next_dac(TO_INTEGER(unsigned(curr_iter))) <= bit_in;
        elsif (mux_dac = "10") then
            next_dac <= (others => '0');
        end if;
        
        -- CONV Register
        next_conv <= curr_conv;
        if (ld_conv = '1') then
            next_conv <= curr_dac((nbits-1) downto 0);
        end if;
        
        -- STOP logic
        stop <= '0';
        if (unsigned(curr_iter) = 0) then
            stop <= '1';
        end if;
    
    end process;
    
    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_dac <= (others => '0');
            curr_conv <= (others => '0');
            curr_iter <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_dac <= next_dac;
            curr_iter <= next_iter;
            curr_conv <= next_conv;
        end if;
    
    end process;
    
    
    -- Controller description
    process(curr_state, soc, comp_in, stop)
    begin
    
        next_state <= curr_state;
        mux_iter <= "00";
        mux_iter <= "00";
        ld_conv <= '0';
        eoc <= '0';
        
        case curr_state is
        
            when wait_soc =>
                mux_iter <= "10";
                mux_dac <= "10";
                
                if (soc = '1') then
                    next_state <= try_1;
                end if;
                
            when try_1 =>
                bit_in <= '1';
                mux_dac <= "01";
                next_state <= confirm_bit;
                
            when confirm_bit =>
                bit_in <= comp_in;
                mux_dac <= "01";
                mux_iter <= "01";
                
                next_state <= try_1;
                if (stop = '1') then
                    next_state <= update_reg;
                end if;
            
            when update_reg =>
                ld_conv <= '1';
                next_state <= done;
            
            when done =>
                eoc <= '1';
                next_state <= wait_soc;   
            
            when others =>
                next_state <= wait_soc;
            
        end case;
    
    end process;

    process(clk, rst)
    begin
    
        if (rst = '1') then
            curr_state <= wait_soc;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    
    end process;

end fsmd;
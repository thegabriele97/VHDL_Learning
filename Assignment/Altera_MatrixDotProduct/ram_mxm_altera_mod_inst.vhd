ram_mxm_altera_mod_inst : ram_mxm_altera_mod PORT MAP (
		aclr	 => aclr_sig,
		address	 => address_sig,
		clock	 => clock_sig,
		data	 => data_sig,
		rden	 => rden_sig,
		wren	 => wren_sig,
		q	 => q_sig
	);

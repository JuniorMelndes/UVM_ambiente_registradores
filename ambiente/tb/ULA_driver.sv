typedef virtual ULA_interface_if.mst ULA_interface_vif;

class ULA_driver extends uvm_driver #(ULA_transaction_in);
	`uvm_component_utils(ULA_driver)

	ULA_interface_vif vif;
	ULA_transaction_in tr;

	function new(string name = "ULA_driver", uvm_component parent = null);
		super.new(name, parent);

	endfunction

    virtual function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	     if(!uvm_config_db#(ULA_interface_vif)::get(this, "", "ULA_vif", vif)) begin
	        `uvm_fatal("NOVIF", "failed to get virtual interface")
    	end
	endfunction

	task run_phase (uvm_phase phase);
		fork
			reset_signals();
			get_and_drive(phase);
		join
	endtask

	virtual task reset_signals();    
		wait (vif.rst === 0);
		forever begin
			vif.A <= '0;
			vif.reg_sel <= '0;
			vif.instru <= '0;  
			vif.valid_ula  <= '0;
			@(posedge vif.rst);
		end
	endtask : reset_signals

	virtual task get_and_drive(uvm_phase phase);
		wait (vif.rst === 0);
		@(posedge vif.rst);
		forever begin
			seq_item_port.get_next_item(tr);
			driver_transfer(tr);
			seq_item_port.item_done();
		end
	endtask : get_and_drive

	
  virtual task driver_transfer(ULA_transaction_in tr);
      @(posedge vif.clk_ula);
      $display("To na ula");
      vif.A = tr.A;
      vif.reg_sel = tr.reg_sel;
      vif.instru = tr.instru;
      vif.valid_ula = '1;
      @(posedge vif.clk_ula iff vif.valid_out);
  endtask : driver_transfer

endclass

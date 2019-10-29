typedef virtual REG_interface_if.mst REG_interface_vif;​

class REG_driver extends uvm_driver #(REG_transaction_in);​
	`uvm_component_utils(REG_driver)​

	REG_interface_vif vif;
	REG_transaction_in tr;

	function new(string name = "REG_driver", uvm_component parent = null);​
		super.new(name, parent);​

	endfunction​

    virtual function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	     if(!uvm_config_db#(REG_interface_vif)::get(this, "", "REG_vif", vif)) begin
	        `uvm_fatal("NOVIF", "failed to get virtual interface")
    	end
	endfunction

	task run_phase (uvm_phase phase);​
		fork​
			reset_signals();​
			get_and_drive(phase);​
		join​
	endtask​

	virtual task reset_signals();    ​
		wait (vif.rst === 0);​
		forever begin​
			vif.valid_reg <= '0;  ​
			vif.data_in  <= '0;​
			vif.addr <= '0; 
			@(negedge vif.rst);​
		end​
	endtask : reset_signals​

	virtual task get_and_drive(uvm_phase phase);​
		wait (vif.rst === 0);​
		@(posedge vif.rst);​
		forever begin​
			seq_item_port.get_next_item(tr);​
			driver_transfer(tr);​
			seq_item_port.item_done();​
		end​
	endtask : get_and_drive

	
  virtual task driver_transfer(REG_transaction_in tr);
      @(posedge vif.clk_reg);
      $display("",);
      vif.data_in <= tr.data_in;      
      vif.addr <= tr.addr;
      vif.valid_reg  <= '1;
  endtask : driver_transfer

endclass: REG_driver
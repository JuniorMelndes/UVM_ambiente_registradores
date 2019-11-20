class REG_monitor extends uvm_monitor;
  `uvm_component_utils(REG_monitor)

  REG_interface_vif  vif;
  event begin_record, end_record;
  REG_transaction_in tr_in;
  uvm_analysis_port #(REG_transaction_in) req_port;
  

  function new(string name, uvm_component parent);
  super.new(name, parent);
    req_port = new ("req_port", this);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(REG_interface_vif)::get(this, "", "REG_vif", vif)) begin
      `uvm_fatal("NOVIF", "failed to get virtual interface")
    end
    tr_in = REG_transaction_in::type_id::create("tr_in", this);
 endfunction

 virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        collect_transactions(phase);
        
    endtask

    virtual task collect_transactions(uvm_phase phase);
		wait (vif.rst === 0);
	  	@(posedge vif.rst);
      	forever begin
        	@(posedge vif.clk_reg iff (vif.valid_reg)) begin
            	begin_tr(tr_in, "monitor_req");
            	tr_in.data_in = vif.data_in;
            	tr_in.addr = vif.addr;
            	req_port.write(tr_in);
            	@(negedge vif.clk_reg);
            	end_tr(tr_in);
        	end
      end
    endtask
  
endclass: REG_monitor

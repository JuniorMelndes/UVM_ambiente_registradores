class ULA_agent extends uvm_agent;​
  `uvm_component_utils(ULA_agent)​

  typedef uvm_sequencer#(ULA_transaction_in) ULA_sequencer;​

  // As portas podem ser modificadas depois (muito provavelmente vão)
  uvm_analysis_port #(ULA_transaction_in) agt_req_port;​
  uvm_analysis_port #(ULA_transaction_out) agt_resp_port;​
  
  ULA_sequencer  sqr;
  ULA_driver     drv;​
  ULA_monitor  mon;

  function new(string name = "ULA_agent", uvm_component parent = null);​
    super.new(name, parent);​
    agt_req_port  = new("agt_req_port", this);​
    agt_resp_port = new("agt_resp_port", this);​
  endfunction​

  virtual function void build_phase(uvm_phase phase);​
    super.build_phase(phase);​​
    mon = ULA_monitor::type_id::create("mon", this);
    sqr = ULA_sequencer::type_id::create("sqr", this);
    ​drv = ULA_driver::type_id::create("drv", this);         
  endfunction​

  virtual function void connect_phase(uvm_phase phase);​
    super.connect_phase(phase);​​
      mon.req_port.connect(agt_req_port);​
      mon.resp_port.connect(agt_resp_port);​
      drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction​

endclass
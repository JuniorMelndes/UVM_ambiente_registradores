class REG_agent extends uvm_agent;​
  `uvm_component_utils(REG_agent)​

  typedef uvm_sequencer#(REG_transaction_in) REG_sequencer;​

  uvm_analysis_port #(REG_transaction_in) agt_req_port;​
  REG_sequencer  sqr;
  REG_driver     drv;​
  REG_monitor    mon;

  function new(string name = "REG_agent", uvm_component parent = null);​
    super.new(name, parent);​
    agt_req_port  = new("agt_req_port", this);​
  endfunction​

  virtual function void build_phase(uvm_phase phase);​
    super.build_phase(phase);​​
    mon = REG_monitor::type_id::create("mon", this);
    sqr = REG_sequencer::type_id::create("sqr", this);
    ​drv = REG_driver::type_id::create("drv", this);         
  endfunction​

  virtual function void connect_phase(uvm_phase phase);​
    super.connect_phase(phase);​​
      mon.req_port.connect(agt_req_port);​
      drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction​

endclass: REG_agent

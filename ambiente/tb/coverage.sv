class coverage extends uvm_component;​
  `uvm_component_utils(coverage)​
 
  ULA_transaction_in req;​
  ULA_transaction_out resp;​
  uvm_analysis_imp#(ULA_transaction_in, coverage) ULA_req_port;​
  uvm_analysis_imp#(ULA_transaction_out, coverage) ULA_resp_port;​
  int min_tr;​
  int n_tr = 0;​
  event end_of_simulation;​

  function new(string name = "coverage", uvm_component parent= null);​
    super.new(name, parent);​
    ULA_req_port = new("ULA_req_port", this);​
    ULA_resp_port = new("ULA_resp_port", this);​
    req=new;​
    resp=new;
    min_tr = 10000;​
  endfunction​

  function void build_phase(uvm_phase phase);​
    super.build_phase (phase);​

  endfunction​

  task run_phase(uvm_phase phase);​
    phase.raise_objection(this);​
    @(end_of_simulation);​
    phase.drop_objection(this);​

  endtask: run_phase​

  function void write(ULA_transaction_out t);​
    n_tr = n_tr + 1;​
    if(n_tr >= min_tr)begin​
      ->end_of_simulation;​
    end​

  endfunction: write​


endclass : coverage​
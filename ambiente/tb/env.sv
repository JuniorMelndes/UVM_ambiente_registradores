class env extends uvm_env;​
    `uvm_component_utils(env)​
  
  REG_agent mst_REG;
  ULA_agent mst_ULA;​
  scoreboard  sb; 
  coverage    cov; 

  function new(string name, uvm_component parent);​
    super.new(name, parent);​
  endfunction: new​

  virtual function void build_phase(uvm_phase phase);​
    super.build_phase(phase);​  
    mst_ULA = ULA_agent::type_id::create("mst_ULA", this);
    mst_REG = REG_agent::type_id::create("mst_REG", this);​
    sb = scoreboard::type_id::create("sb", this);
    cov = coverage::type_id::create("cov",this);
  endfunction​

  virtual function void connect_phase(uvm_phase phase);​
    super.connect_phase(phase);​
    //mst_ULA.agt_req_port.connect(cov.ULA_req_port);​
    mst_ULA.agt_resp_port.connect(cov.ULA_resp_port);​
    mst_ULA.agt_resp_port.connect(sb.ap_comp);​
    mst_ULA.agt_req_port.connect(sb.ap_rfm_ULA);      
  	mst_REG.agt_req_port.connect(sb.ap_rfm_REG);
  endfunction​

endclass: env
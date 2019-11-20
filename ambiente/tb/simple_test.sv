​class simple_test extends uvm_test;​
  `uvm_component_utils(simple_test)​
	env env_h;
	ULA_sequence_in ULA_seq;
	REG_sequence_in REG_seq;

  function new(string name, uvm_component parent);​
		super.new(name, parent);​

  endfunction: new​

	virtual function void build_phase(uvm_phase phase);​
		super.build_phase(phase);​
	    env_h = env::type_id::create("env_h", this);
	​    ULA_seq = ULA_sequence_in::type_id::create("ULA_seq", this);
		REG_seq = REG_sequence_in::type_id::create("REG_seq", this);
	endfunction​

	task run_phase(uvm_phase phase);​
	fork
	    ULA_seq.start(env_h.mst_ULA.sqr);
		REG_seq.start(env_h.mst_REG.sqr);
	join
	endtask: run_phase​

endclass: simple_test
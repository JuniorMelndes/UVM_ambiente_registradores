import "DPI-C" context function int my_sqrt(int x);​

class refmod extends uvm_component;
  `uvm_component_utils(refmod)​

  ULA_transaction_in ULA_tr_in;​
  REG_transaction_in REG_tr_in;​
  uvm_analysis_imp #(ULA_transaction_in, refmod) ULA_in;
  uvm_analysis_imp #(REG_transaction_in, refmod) REG_in;​
  uvm_analysis_port #(transaction_out) out; ​
  
  event begin_refmodtask, begin_record, end_record;​

  function new(string name = "refmod", uvm_component parent);​
    super.new(name, parent);​
    ULA_in = new("ULA_in", this);​
    REG_in = new("REG_in", this);
    out = new("out", this);​

  endfunction​

  virtual function void build_phase(uvm_phase phase);​
    super.build_phase(phase);​
    tr_out = transaction_out::type_id::create("tr_out", this);​

  endfunction: build_phase​

  virtual task run_phase(uvm_phase phase);​
    super.run_phase(phase);​
    fork​
      refmod_task();​
      record_tr();​
    join​
  endtask: run_phase​

  task refmod_task();​
    forever begin​
      @begin_refmodtask;​
      tr_out = transaction_out::type_id::create("tr_out", this);​
      -> begin_record;​
		case(ULA_tr_in.instruc)
			2'b00: begin
				tr_out.data = ULA_tr_in.data + ULA_tr_in.regi.data;
			end​
			
			2'b01: begin
				if(ULA_tr_in.data >= ULA_tr_in.regi.data)
					tr_out.data = ULA_tr_in.data - ULA_tr_in.regi.data;
				else
					tr_out.data = ULA_tr_in.regi.data - ULA_tr_in.data;
			end​
			
			2'b10: begin​
				tr_out.data = ULA_tr_in.data + 1;
			end​
			
			2'b11: begin
				tr_out.data = ULA_tr_in.regi.data +1;
			end​

		end​case
		REG_tr_in.data = tr_out.data;
      
      #10;​
      -> end_record;​
      out.write(tr_out);​
    end​

  endtask : refmod_task​

  ​virtual function write (transaction_in t);​
    tr_in = transaction_in#()::type_id::create("tr_in", this);​
    tr_in.copy(t);​
    -> begin_refmodtask;​
  endfunction​

  virtual task record_tr();​
    forever begin​
      @(begin_record);​
      begin_tr(tr_out, "refmod");​
      @(end_record);​
      end_tr(tr_out);​
    end​
  endtask​

endclass: refmod​
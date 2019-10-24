import "DPI-C" context function int soma(int x, int y);​
import "DPI-C" context function int dif(int x, int y);
import "DPI-C" context function int incre(int x);
`uvm_analysis_imp_decl(ULA_)
`uvm_analysis_imp_decl(REG_)

class refmod extends uvm_component;
  `uvm_component_utils(refmod)​

  ULA_transaction_in ULA_tr_in;​
  REG_transaction_in REG_tr_in;​
  uvm_analysis_imp #(ULA_transaction_in, refmod) ULA_in;
  uvm_analysis_imp #(REG_transaction_in, refmod) REG_in;​
  uvm_analysis_port #(transaction_out) out; ​
  event begin_refmodtask, begin_record, end_record;

  bit [15:0] registrador[0] = 16'hC4F3;
  bit [15:0] registrador[1] = 16'hB45E;
  bit [15:0] registrador[2] = 16'hD1E5;
  bit [15:0] registrador[3] = 16'h1DE4;

  bit [15:0] registrador_ativo;

  
  function new(string name = "refmod", uvm_component parent);​
    super.new(name, parent);​
    ULA_in = new("ULA_in", this);​
    REG_in = new("REG_in", this);
    out = new("out", this);​

  endfunction​

  virtual function void build_phase(uvm_phase phase);​
    super.build_phase(phase);​​

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
		case(ULA_tr_in.instru)

			registrador_ativo = REG_tr_in.data_in

			2'b00: begin
				tr_out.data_out = soma(ULA_tr_in.A, registrador_ativo);
			end​
			
			2'b01: begin
				if(ULA_tr_in.data >= registrador_ativo)
					tr_out.data_out = dif(ULA_tr_in.A, registrador_ativo);
				else
					tr_out.data_out = dif(registrador_ativo, ULA_tr_in.A);
			end​
			
			2'b10: begin​
				tr_out.data_out = incre(ULA_tr_in.A);
			end​
			
			2'b11: begin
				tr_out.data_out = incre(registrador_ativo);
			end​

			case(ULA_transaction_in.reg_sel)
				2'b00: begin
					registrador[0] = tr_out.data_out;
				end​
				2'b01: begin
					registrador[1] = tr_out.data_out;
				end​
				2'b10: begin
					registrador[2] = tr_out.data_out;
				end​
				2'b11: begin
					registrador[3] = tr_out.data_out;
				end​
			end​case
		end​case
      
      #10;​
      -> end_record;​
      out.write(tr_out);​
    end​

  endtask : refmod_task​
	//escrever dois writes
  ​virtual function write (transaction_in t);​
    ULA_tr_in = transaction_in#()::type_id::create("ULA_tr_in", this);​
    ULA_tr_in.copy(t);​
    -> begin_refmodtask;​
  endfunction​
	virtual function write (transaction_in t);
		REG_tr_in = transaction_in#()::type_id::create("REG_tr_in", this);
		REG_tr_in.copy(t);
		-> begin_refmodtask	
	endfunction
  virtual task record_tr();​
    forever begin​
      @(begin_record);​
      begin_tr(tr_out, "refmod");​
      @(end_record);​
      end_tr(tr_out);​
    end​
  endtask​

endclass: refmod​

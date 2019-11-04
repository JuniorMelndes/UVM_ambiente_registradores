import "DPI-C" context function int soma(int x, int y);​
import "DPI-C" context function int dif(int x, int y);
import "DPI-C" context function int incre(int x);
`uvm_analysis_imp_decl(_ULA)
`uvm_analysis_imp_decl(_REG)

class refmod extends uvm_component;
  `uvm_component_utils(refmod)​

  ULA_transaction_in ULA_tr_in;​
  ULA_transaction_out ULA_tr_out;​
  REG_transaction_in REG_tr_in;​
  uvm_analysis_imp_ULA #(ULA_transaction_in, refmod) _ULA;
  uvm_analysis_imp_REG #(REG_transaction_in, refmod) _REG;​
  uvm_analysis_port #(ULA_transaction_out) out; ​
  event begin_refmodtask, begin_record, end_record, begin_reg;
  bit [15:0] registrador[4];

  bit [15:0] registrador_ativo;
  
 

  
  function new(string name = "refmod", uvm_component parent);​
    super.new(name, parent);​
    _ULA = new( "_ULA", this);​
    _REG = new("_REG", this);
    out = new("out", this);​

	  registrador[0] = 16'hC4F3;
	  registrador[1] = 16'hB45E;
	  registrador[2] = 16'hD1E5;
	  registrador[3] = 16'h1DE4;
  endfunction​

  virtual function void build_phase(uvm_phase phase);​
    super.build_phase(phase);​​

  endfunction: build_phase​

  virtual task run_phase(uvm_phase phase);​
    super.run_phase(phase);​
    fork​
    	refmod_task_reg();
		refmod_task();​
		record_tr();​
    join​
  endtask: run_phase​

  task refmod_task_reg();
	forever begin
	@begin_reg;
			case(REG_tr_in.addr)
				2'b00: begin
					registrador[0] = REG_tr_in.data_in;
				end​
				2'b01: begin
					registrador[1] = REG_tr_in.data_in;
				end​
				2'b10: begin
					registrador[2] = REG_tr_in.data_in;
				end​
				2'b11: begin
					registrador[3] = REG_tr_in.data_in;
				end
		endcase
	end
  endtask
			
  task refmod_task();​
    forever begin​
		@begin_refmodtask;​	
      	ULA_tr_out = ULA_transaction_out::type_id::create("ULA_tr_out", this);​
      	-> begin_record;​
		case(ULA_tr_in.reg_sel)
				2'b00: begin
					registrador_ativo = registrador[0];
				end​
				2'b01: begin
					registrador_ativo = registrador[1];
				end​
				2'b10: begin
					registrador_ativo = registrador[2];
				end​
				2'b11: begin
					registrador_ativo = registrador[3];
				end
		endcase

		case(ULA_tr_in.instru)
			2'b00: begin
				ULA_tr_out.data_out = soma(ULA_tr_in.A, registrador_ativo);
			end​
			
			2'b01: begin
				if(ULA_tr_in.A >= registrador_ativo)
					ULA_tr_out.data_out = dif(ULA_tr_in.A, registrador_ativo);
				else
					ULA_tr_out.data_out = dif(registrador_ativo, ULA_tr_in.A);
			end​
			
			2'b10: begin​
				ULA_tr_out.data_out = incre(ULA_tr_in.A);
			end​
			
			2'b11: begin
				ULA_tr_out.data_out = incre(registrador_ativo);
			end​
		end​case
      
      #10;​
      -> end_record;​
      out.write(ULA_tr_out);​
    end​

  endtask : refmod_task​
	//escrever dois writes
  ​virtual function write_ULA (ULA_transaction_in t);​
    ULA_tr_in = ULA_transaction_in#()::type_id::create("ULA_tr_in", this);​
    ULA_tr_in.copy(t);​
    -> begin_refmodtask;​
  endfunction​
  
  virtual function write_REG (REG_transaction_in t);
	REG_tr_in = REG_transaction_in#()::type_id::create("REG_tr_in", this);
	REG_tr_in.copy(t);
	-> begin_reg;
  endfunction
  
  virtual task record_tr();​
    forever begin​
      @(begin_record);​
      begin_tr(ULA_tr_out, "refmod");​
      @(end_record);​
      end_tr(ULA_tr_out);​
    end​
  endtask​

endclass: refmod​

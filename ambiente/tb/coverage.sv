`uvm_analysis_imp_decl(_ULAreq)
`uvm_analysis_imp_decl(_ULAresp)
`uvm_analysis_imp_decl(_REGreq)


class coverage extends uvm_component;
  `uvm_component_utils(coverage)
 
  ULA_transaction_in req;
  ULA_transaction_out resp;
  REG_transaction_in reg_req;
  uvm_analysis_imp_ULAreq#(ULA_transaction_in, coverage) ULA_req_port;
  uvm_analysis_imp_ULAresp #(ULA_transaction_out, coverage) ULA_resp_port;
  uvm_analysis_imp_REGreq #(REG_transaction_in, coverage) REG_req_port;
  int min_tr;
  int n_tr = 0;
  event end_cover, end_trans;
///////////////////////////////////////////////////////////////////////////////////////////////
//**************************Cobertura das transações ******************************************
///////////////////////////////////////////////////////////////////////////////////////////////

  covergroup transacoes;

    trans: coverpoint resp.data_out {option.at_least = min_tr;
                                      bins total = {[32'h0000_0000:32'hffff_ffff]};
                                    }

  endgroup : transacoes


///////////////////////////////////////////////////////////////////////////////////////////////
//**************************Cobertura das instruções ******************************************
///////////////////////////////////////////////////////////////////////////////////////////////
  covergroup instrucoes;
    
    instru:coverpoint req.instru {option.at_least = 1000;
                                  bins soma  = {2'b00};
                                  bins sub   = {2'b01};
                                  bins incrA = {2'b10};
                                  bins incrR = {2'b11};
                                 }
  endgroup : instrucoes

///////////////////////////////////////////////////////////////////////////////////////////////
//**************************Cobertura das combinações de valores ******************************
///////////////////////////////////////////////////////////////////////////////////////////////
  covergroup combinations;

    A: coverpoint req.A{option.at_least = 1000;
                        bins a_pequeno = {[16'h0000:16'h2710]};//0-10000
                        bins a_medio   = {[16'h4e20:16'h7530]};//20000-30000
                        bins a_grande  = {[16'hc350:16'hea60]};//50000 -60000
                       }
    register : coverpoint reg_req.data_in{option.at_least = 1000;
                        bins r_pequeno = {[16'h0000:16'h2710]};//0-10000
                        bins r_medio   = {[16'h4e20:16'h7530]};//20000-30000
                        bins r_grande  = {[16'hc350:16'hea60]};//50000 -60000
                       }

  endgroup: combinations

  //Para verificar em combinação com os registradores, tenho que fazer uma nova
  //porta. Fazer depois porque quero descobrir como separo os testes
  //Falta fazer o cross nas combinações


  function new(string name = "coverage", uvm_component parent= null);
    super.new(name, parent);
    ULA_req_port = new("ULA_req_port", this);
    ULA_resp_port = new("ULA_resp_port", this);
    REG_req_port = new("REG_req_port", this);
    req=new;
    resp=new;
    reg_req = new;
    min_tr = 10000; 
    instrucoes = new;
    combinations = new;
    transacoes = new;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase (phase);

  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    @(end_trans);
    @(end_cover);
    phase.drop_objection(this);
  endtask: run_phase

  function void write_ULAresp(ULA_transaction_out t);
    resp.copy(t);
    transacoes.sample();
    if($get_coverage() == 100)
       ->end_trans;
  endfunction

  function void write_ULAreq(ULA_transaction_in t);
    req.copy(t);
    instrucoes.sample();
    combinations.sample();
    if($get_coverage() == 100)
       ->end_cover;
  endfunction


  function void write_REGreq(REG_transaction_in t);
    reg_req.copy(t);
  endfunction


endclass : coverage

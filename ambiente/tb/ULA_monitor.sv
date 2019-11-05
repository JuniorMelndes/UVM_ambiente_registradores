class ULA_monitor extends uvm_monitor;
  `uvm_component_utils(ULA_monitor)

  ULA_interface_vif  vif;
  event begin_record, end_record;
  ULA_transaction_in tr_in;
  ULA_transaction_out tr_out;
  
  //Pode ser que as portas mudem depois 
  uvm_analysis_port #(ULA_transaction_in) req_port;
  uvm_analysis_port #(ULA_transaction_out) resp_port;

  function new(string name, uvm_component parent);
  super.new(name, parent);
    req_port = new ("req_port", this);
    resp_port = new ("resp_port", this);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(ULA_interface_vif)::get(this, "", "ULA_vif", vif)) begin
      `uvm_fatal("NOVIF", "failed to get virtual interface")
    end
    tr_in = ULA_transaction_in::type_id::create("tr_in", this);
    tr_out = ULA_transaction_out::type_id::create("tr_out", this);
 endfunction

 virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        collect_transactions(phase);
    endtask

    virtual task collect_transactions(uvm_phase phase);
      forever begin
         @(posedge vif.clk_ula) begin
          @(posedge vif.clk_ula);
          if(!vif.valid_ula) begin
            @(posedge vif.valid_ula)
            begin_tr(tr_in, "ula_req");
            tr_in.A = vif.A;
            tr_in.reg_sel = vif.reg_sel;
            tr_in.instru = vif.instru;
            req_port.write(tr_in);
            @(negedge vif.clk_ula);
            end_tr(tr_in);
          end
          else if(!vif.valid_out)begin
            @(posedge vif.valid_out);
            begin_tr(tr_out, "ula_resp");
            tr_out.data_out = vif.data_out;
            resp_port.write(tr_out);
            @(negedge vif.clk_ula);
            end_tr(tr_out);
          end
        end
      end
    endtask
  
endclass

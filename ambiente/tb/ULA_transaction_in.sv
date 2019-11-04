class ULA_transaction_in extends uvm_sequence_item;

  rand bit [15:0]  A;
  rand bit [1:0]   reg_sel;
  rand bit [1:0]   instru;


  function new(string name = "");
    super.new(name);
  endfunction

  `uvm_object_param_utils_begin(ULA_transaction_in)
    `uvm_field_int(A , UVM_UNSIGNED)
    `uvm_field_int(reg_sel , UVM_UNSIGNED)
    `uvm_field_int(instru , UVM_UNSIGNED)
    //`uvm_field_int(valid_ula , UVM_UNSIGNED)
  `uvm_object_utils_end

  function string convert2string();
    return $sformatf("{A = %d, reg_sel = %d, instru = %d}", A, reg_sel, instru);
  endfunction

endclass

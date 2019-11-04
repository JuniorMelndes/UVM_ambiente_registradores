class ULA_transaction_out extends uvm_sequence_item;

  rand bit [31:0] data_out;
 
  function new(string name = "");
    super.new(name);

  endfunction

  `uvm_object_param_utils_begin(ULA_transaction_out)
    `uvm_field_int(data_out, UVM_UNSIGNED)
  `uvm_object_utils_end

  function string convert2string();
    return $sformatf("{data_o = %d}",data_out);

  endfunction

endclass

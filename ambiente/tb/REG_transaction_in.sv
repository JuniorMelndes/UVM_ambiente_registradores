class REG_transaction_in extends uvm_sequence_item;

  rand bit [15:0] data_in;
  rand bit [1:0]  addr;

  function new(string name = "");
    super.new(name);

  endfunction

  `uvm_object_param_utils_begin(REG_transaction_in)
    `uvm_field_int(data_in, UVM_UNSIGNED)
    `uvm_field_int(addr, UVM_UNSIGNED)
  `uvm_object_utils_end

  function string convert2string();
    return $sformatf("{data_in = %h, addr = %h}",data_in,addr);

  endfunction

endclass

class REG_sequence_in extends uvm_sequence #(REG_transaction_in);​
	`uvm_object_utils(REG_sequence_in)​

 	function new(string name="REG_sequence_in");​
      super.new(name);​

  endfunction: new​

	task body();​
	  REG_transaction_in tr;​
		forever begin​
			tr = REG_transaction_in::type_id::create("tr");​
      start_item(tr);​
	      assert(tr.randomize());​
      finish_item(tr);​
    end​
	endtask​

endclass: REG_sequence_in
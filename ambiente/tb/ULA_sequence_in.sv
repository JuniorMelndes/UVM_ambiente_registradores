class ULA_sequence_in extends uvm_sequence #(ULA_transaction_in);
	`uvm_object_utils(ULA_sequence_in)
 
 	function new(string name="ULA_sequence_in");
      super.new(name);

  endfunction: new

	task body();
	  	ULA_transaction_in tr;
		forever begin
			tr = ULA_transaction_in::type_id::create("tr");
	      	start_item(tr);
		      	assert(tr.randomize());
	      	finish_item(tr);
    	end
	endtask

endclass: ULA_sequence_in

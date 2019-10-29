package pkg;​
	`include "uvm_macros.svh"​
	 import uvm_pkg::*;​
​
  `include "./ULA_transaction_in.sv"​
  `include "./ULA_transaction_out.sv"
  `include "./ULA_sequence_in.sv"
  `include "./ULA_driver.sv"
  `include "./ULA_monitor.sv"​
  `include "./ULA_agent.sv"
  
  `include "./REG_transaction_in.sv"​
  `include "./REG_sequence_in.sv"​
  `include "./REG_driver.sv"​
  `include "./REG_monitor.sv"​
  `include "./REG_agent.sv"

  `include "./coverage.sv"​​
  `include "./refmod.sv"​
  `include "./scoreboard.sv"​
  `include "./env.sv"​
  `include "./simple_test.sv"
  
endpackage

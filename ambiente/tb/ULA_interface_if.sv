interface ULA_interface_if(input clk_ula, rst);​  
  logic [15:0]  A;​
  logic [1:0]   reg_sel;  
  logic [1:0]   instru;​
  logic         valid_ula;
  logic [31:0]  data_out;
  logic         valid_out;

  modport mst(input clk_ula, rst, data_out, valid_out, output A, reg_sel, instru, valid_ula);​
  modport slv(input clk_ula, rst,  A, reg_sel, instru, valid_ula, output data_out, valid_out);​
endinterface

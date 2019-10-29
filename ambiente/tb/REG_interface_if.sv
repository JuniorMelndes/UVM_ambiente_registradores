interface REG_interface_if(input clk_reg, rst);​
  logic        valid_reg;​
  logic [15:0] data_in;​
  logic [1:0]  addr;​

  modport mst(input clk_reg, rst,  output  valid_reg, data_in, addr);​

endinterface
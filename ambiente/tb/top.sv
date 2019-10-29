module top;​
  import uvm_pkg::*;
  import pkg::*;
  
  logic clk;​
  logic rst;​

  initial begin​
    clk = 1;​
    rst = 1;​
    #20 rst = 0;​
    #20 rst = 1;​
  end​

  always #10 clk = !clk;​

​ ULA_interface_if ULA_dut_if(.clk_ula(clk), .rst(rst));​
 ula my_ula(.clk_ula(clk),​
              .rst(rst),​
              .valid_ula(ULA_dut_if.valid_ula),​
              .A(ULA_dut_if.A),​
              .reg_sel(ULA_dut_if.reg_sel),​
              .instru(ULA_dut_if.instru)​
  );

REG_interface_if REG_dut_if(.clk_reg(clk), .rst(rst));​
 rb my_rb(.clk_reg(clk),​
              .rst(rst),​
              .valid_reg(REG_dut_if.valid_reg),​
              .addr(REG_dut_if.addr),​
              .data_in(REG_dut_if.data_in)​
  );
  
  initial begin​
    `ifdef XCELIUM​
      $recordvars();​
    `endif​
    `ifdef VCS​
      $vcdpluson;​
    `endif​
    `ifdef QUESTA​
      $wlfdumpvars();​
      set_config_int("*", "recording_detail", 1);​
    `endif​
  end

  initial begin
    uvm_config_db#(ULA_interface_vif)::set(uvm_root::get(), "*", "ULA_vif", ULA_dut_if);
    uvm_config_db#(REG_interface_vif)::set(uvm_root::get(), "*", "REG_vif", REG_dut_if);
  end

  initial begin
    run_test("simple_test");​
  end

endmodule
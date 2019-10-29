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

​ ULA_interface_if dut_if(.clk(clk), .rst(rst));​
 ula my_ula(.clk_i(clk),​
              .rstn_i(rst),​
              .valid_ula(dut_if.valid_ula),​
              .A(dut_if.A),​
              .reg_sel(dut_if.reg_sel),​
              .instru(dut_if.instru)​
  );

REG_interface_if dut_if(.clk(clk), .rst(rst));​
 rb my_rb(.clk_i(clk),​
              .rstn_i(rst),​
              .valid_reg(dut_if.valid_reg),​
              .addr(dut_if.addr),​
              .data_in(dut_if.data_in)​
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
    uvm_config_db#(ULA_interface_vif)::set(uvm_root::get(), "*", "vif", dut_if);
    uvm_config_db#(REG_interface_vif)::set(uvm_root::get(), "*", "vif", dut_if);
  end

  initial begin
    run_test("simple_test");​
  end

endmodule
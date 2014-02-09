
/*----------------------------------------------------
  top root for including DUTs and testbenches
------------------------------------------------------*/

`timescale 1ns/10ps

`include "xbus_def.sv"
`include "xbus_vif.sv"
`include "xbus_pkg.sv"
`include "xbus_seq_lib_pkg.sv"
`include "xbus_test_pkg.sv"

// top module
module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // xbus Test Pkg
  import xbus_pkg::*;
  import xbus_seq_lib_pkg::*;
  import xbus_test_pkg::*;

  // signals
  reg local_clk;

  // build up virtual interface
  xbus_vif #(
    .C_ADDR_WIDTH   (`DEF_C_ADDR_WIDTH),
    .C_BE_WIDTH     (`DEF_C_BE_WIDTH),
    .C_RDATA_WIDTH  (`DEF_C_RDATA_WIDTH),
    .C_WDATA_WIDTH  (`DEF_C_WDATA_WIDTH)
  ) u_xbus_vif_0
  (.local_clk(local_clk));

  // Env set and top test root set
  initial begin
    connect_vif();
    run_test();
  end

  // connect virtual interface
  task connect_vif;
    // set xbus_vif_0 to xbus_master_0
    uvm_config_db#(virtual interface xbus_vif)::set(uvm_root::get(), "*m_xbus_env.m_master_agent[*0]*", "m_vif", u_xbus_vif_0);

    // set xbus_vif_0 to xbus_slave_0
    uvm_config_db#(virtual interface xbus_vif)::set(uvm_root::get(), "*m_xbus_env.m_slave_agent[*0]*", "m_vif", u_xbus_vif_0);
  endtask : connect_vif

  // connect conf
  task connect_conf;
  endtask : connect_conf

  // init set for all reg signals
  initial begin
    local_clk = 1'b0;
  end

  // clk trigger
  always
  #(`DEF_C_CLK_PERIOD) local_clk = ~ local_clk;

  // dump waveform
  initial begin
    $dumpfile("mastersv_slavesv.vcd");
    $dumpvars(0, top);
  end

endmodule

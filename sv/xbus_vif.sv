

/*----------------------------------------------------
// XBUS virtual interface
------------------------------------------------------*/

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

//define XBUS virtual interface
interface xbus_vif #(
  parameter REQ_WIDTH   = 1,
  parameter RW_WIDTH    = 1,
  parameter ADDR_WIDTH  = 14,
  parameter ACK_WIDTH   = 1,
  parameter BE_WIDTH    = 4,
  parameter RDATA_WIDTH = 32,
  parameter WDATA_WIDTH = 32,
  parameter string name = "vif"
  ) (input local_clk);

// XBUS interface config
  bit has_checks = 1;
  bit has_coverage = 1;
  bit has_performance = 1;

// XBUS interface lists
  logic [C_REQ_WIDTH-1:0]   req;
  logic [C_RW_WIDTH-1:0]    rw;
  logic [C_ADDR_WIDTH-1:0]  addr;
  logic [C_ACK_WIDTH-1:0]   ack;
  logic [C_BE_WIDTH-1:0]    be;
  logic [C_RDATA_WIDTH-1:0] rdata;
  logic [C_WDATA_WIDTH-1:0] wdata;

// for XBUS slave port interface
  modport slave (
    input   local_clk,
    input   req,
    input   rw,
    input   addr,
    output  ack,
    input   be,
    input   wdata,
    output  rdata
  );

// for XBUS master port interface
  modport master (
    input   local_clk,
    output  req,
    output  rw,
    output  addr,
    input   ack,
    output  be,
    output  wdata,
    input   rdata
  );

  // check XBUS protocol assertions
  always @(negedge local_clk)
  begin
    // addr must not be X or Z during R/W phase (req = 1'b1)
    assert_addr : assert property (
      disable iff(!has_checks)
      ($onehot(req) |-> !$isunknown(addr)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("addr = %d went to X or Z during R/W phase when the req = %d", addr, req)})

    // rw must not be X or Z during R/W phase (req = 1'b1)
    assert_rw : assert property (
      disable iff(!has_checks)
      ($onehot(req) |-> !$isunknown(rw)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("rw = %d went to X or Z during R/W phase when the req = %d", rw, req)})

    // be must not be X or Z during R/W phase (req = 1'b1)
    assert_be : assert property (
      disable iff(!has_checks)
      ($onehot(req) && !$isunknown(rw) |-> !$isunknown(be)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("be = %d went to X or Z during R/W phase when the req = %d", be, req)})

    // wdata must not be X or Z during R phase (req = 1'b1 and rw = 1'b1)
    assert_wdata : assert property (
      disable iff(!has_checks)
      ($onehot(req) && $onehot(rw) |-> !$isunknown(wdata)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("wdata = %d went to X or Z during W phase when the req = %d and rw = %d", wdata, req, rw)})

    // rdata must not be X or Z during R phase (req = 1'b1 and rw = 1'b0)
    assert_rdata : assert property (
      disable iff(!has_checks)
      ($onehot(req) && !$onehot(rw) && $onehot(ack) |-> !$isunknown(rdata)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("rdata = %d went to X or Z during R phase when the req = %d, ack = %d, and rw = %d", rdata, req, ack, rw)})

    // ack must not be X or Z during R/W phase (req = 1'b1)
    // ...
  end
endinterface : xbus_vif

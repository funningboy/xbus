
/*----------------------------------------------------
// xbus transfer
------------------------------------------------------*/

`ifndef XBUS_TRANSFER_SV
`define XBUS_TRANSFER_SV

class xbus_base extends uvm_sequence_item;
  /* transfer id */
  rand longint id;

  /* transfer begin/end cycle */
  rand longint begin_cycle = 0;
  rand longint end_cycle = 0;

  /* transfer begin/endsim time */
  rand longint begin_time = 0;
  rand longint end_time = 0;

  // no delay wait ... like the master must be waited unitl the slave is ready that can send the next trx
  // define your constrains here
  // constraint ...

  // uvm field register
  `uvm_object_utils_begin(xbus_base)
  `uvm_field_int (id, uvm_default)
  `uvm_field_int (begin_cycle, uvm_default)
  `uvm_field_int (end_cycle, uvm_default)
  `uvm_field_int (begin_time, uvm_default)
  `uvm_field_int (end_time, uvm_default)
  `uvm_object_utils_end

  // new
  function new (string name = "xbus_base");
    super.new(name);
  endfunction : new
endclass : xbus_base

class xbus_transfer extends xbus_base;
  rand xbus_type::rw_enum rw;
  rand longint addr;
  rand longint data;
  rand longint byten;

  constraint c_rw     { xbus_type::READ <= rw && rw <= xbus_type::WRITE; }
  constraint c_addr   { 0 <= addr && addr <= 2 ** `def_c_addr_width-1; }
  constraint c_data   { 0 <= data && data <= 2 ** `def_c_wdata_width-1; } // the r/w data width is the same
  constraint c_byten  { 0 <= byten && byten <= 2 ** `def_c_be_width-1; }

  // uvm field register
  `uvm_object_utils_begin(xbus_transfer)
  `uvm_field_enum (xbus_type::rw_enum, rw, uvm_default)
  `uvm_field_int (addr, uvm_default)
  `uvm_field_int (data, uvm_default)
  `uvm_field_int (byten, uvm_default)
  `uvm_object_utils_end

  // new
  function new (string name = "xbus_transfer");
    super.new(name);
  endfunction : new

endclass : xbus_transfer

`endif // XBUS_TRANSFER_SV

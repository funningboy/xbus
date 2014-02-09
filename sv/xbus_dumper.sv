

/*----------------------------------------------------
// XBUS_Dumper.sv
------------------------------------------------------*/
`ifndef XBUS_DUMPER_SV
`define XBUS_DUMPER_SV

class xbus_dumper extends uvm_monitor;

  /* file ptr */
  integer m_file;

  // uvm field register
  `uvm_component_utils_begin(xbus_dumper)
  `uvm_component_utils_end

  // new
  function new (string name = "xbus_dumper", uvm_component parent);
    super.new(name, parent);
    // create dumper file by it's unique id
    m_file = $fopen({$psprintf("./trx/%h.trx", this)}, "w");
  endfunction : new

  /* uvm phase */
  extern virtual function void do_header_dump(string name);
  extern virtual function void do_write_dump(xbus_transfer wr_trx);
  extern virtual function void do_read_dump(xbus_transfer rd_trx);

endclass : xbus_dumper

// do header dump
// name : the hier instance name
function void xbus_dumper::do_header_dump(string name);
  $fwrite(m_file, {$psprintf("# %s\n", name)});
  $fwrite(m_file, {$psprintf("# %16s, %16s, %16s, %16s, %16s, %16s, %16s,\n",
  "begin_cycle",
  "end_cycle",
  "begin_time",
  "end_time",
  "r/w",
  "addr",
  "data(byten)")});
endfunction : do_header_dump

// do read_dump as the same as method void(`begin_tr(trx)), void(`end_tr(trx))
function void xbus_dumper::do_read_dump(xbus_transfer rd_trx);
  `uvm_info(get_type_name(), {$psprintf("\n%s", rd_trx.sprint())}, UVM_HIGH)
  $fwrite(m_file, {$psprintf("%16h, %16h, %16h, %16h, %s, %16h, %16h(%16h),\n",
  rd_trx.begin_cycle,
  rd_trx.end_cycle,
  rd_trx.begin_time,
  rd_trx.end_time,
  "r",
  rd_trx.addr,
  rd_trx.data,
  rd_trx.byten)});
endfunction : do_read_dump

// do write dump as the same as method void(`begin_tr(trx)), void(`end_tr(trx))
function void xbus_dumper::do_write_dump(xbus_transfer wr_trx);
  `uvm_info(get_type_name(), {$psprintf("\n%s", wr_trx.sprint())}, UVM_HIGH)
  $fwrite(m_file, {$psprintf("%16h, %16h, %16h, %16h, %s, %16h, %16h(%16h),\n",
  wr_trx.begin_cycle,
  wr_trx.end_cycle,
  wr_trx.begin_time,
  wr_trx.end_time,
  "w",
  wr_trx.addr,
  wr_trx.data,
  wr_trx.byten)});
endfunction : do_write_dump

`endif // XBUS_DUMPER_SV


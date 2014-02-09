
/*----------------------------------------------------
 xbus sample scoreboard, check trx is completed or not
------------------------------------------------------*/

`ifndef XBUS_SCOREBOARD_SV
`define XBUS_SCOREBOARD_SV

class xbus_scoreboard extends uvm_scoreboard;

  // tlm analysis imp
  uvm_analysis_imp #(xbus_transfer, xbus_scoreboard) item_collected_imp;

  // expec mem map table
  int unsigned m_mem_expected[int unsigned];

  // uvm field register
  `uvm_component_utils_begin(xbus_scoreboard);
  `uvm_component_utils_end

  // new
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_imp = new("item_collected_imp", this);
  endfunction : new

  // callback func from uvm_analysis_imp
  extern virtual function void write(xbus_transfer trx);

  // veify items
  extern virtual function void verify_by_memory(xbus_transfer trx);
  extern virtual function void verify_by_connect(xbus_transfer trx);
  extern virtual function void verify_to_c(xbus_transfer trx);

  extern virtual function void populate_write_transfer(xbus_transfer trx);
  extern virtual function void populate_read_transfer(xbus_transfer trx);

endclass : xbus_scoreboard


// tlm write() callback func
function void xbus_scoreboard::write(xbus_transfer trx);
  verify_by_memory(trx);
  verify_by_connect(trx);
  verify_to_c(trx);
endfunction : write


// verify_by_memory
function void xbus_scoreboard::verify_by_memory(xbus_transfer trx);
  if (trx.rw == xbus_type::WRITE)
    populate_write_transfer(trx);
  else
    populate_read_transfer(trx);
endfunction : verify_by_memory


// populate write trx
function void xbus_scoreboard::populate_write_transfer(xbus_transfer trx);
  int unsigned byten_data = 0;
  bit [3:0] tmp;

  $cast(tmp, trx.byten);

  // byten_data
  foreach (tmp[i]) begin
    byten_data = byten_data + (2 ** 8 ** (i)) * tmp[i] * 255;
  end

  // store to mem expected table, orverwrite the mem data when the mem address has exist
  if (!m_mem_expected.exists(trx.addr))
    m_mem_expected[trx.addr] = trx.data & byten_data;
  else
    m_mem_expected[trx.addr] = m_mem_expected[trx.addr] & trx.data & byten_data;

  `uvm_info(get_type_name(), {$psprintf("stored addr %h, data %h, byten %h, byten_data %h, stored_data %h",
  trx.addr, trx.data, trx.byten, byten_data, trx.data & byten_data)}, UVM_LOW)

endfunction : populate_write_transfer


// populate read trx
function void xbus_scoreboard::populate_read_transfer(xbus_transfer trx);

  // check the mem has correct data or not when the addr is valid
  if (!m_mem_expected.exists(trx.addr))
    `uvm_error("xbus_scoreboard", {$psprintf("read the null data in the address %h", trx.addr)})
  else begin
    if (m_mem_expected[trx.addr] != trx.data)
      `uvm_error("xbus_scoreboard", {$psprintf("read data at address %h, the data %h is not match the expected data %h", trx.addr, trx.data, m_mem_expected[trx.addr])})
  end

endfunction : populate_read_transfer


// verify_by_connect, make sure the trx has completed no lost.
function void xbus_scoreboard::verify_by_connect(xbus_transfer trx);
endfunction : verify_by_connect


// verify_to_c, make sure the sv answer is eq to c answer
function void xbus_scoreboard::verify_to_c(xbus_transfer trx);
endfunction : verify_to_c


`endif // XBUS_SCOREBOARD_SV

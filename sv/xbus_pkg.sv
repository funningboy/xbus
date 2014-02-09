


`ifndef XBUS_PKG_SV
`define XBUS_PKG_SV

package xbus_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  /* xbus common set */
  `include "xbus_type.sv"

  /* xbus conf such as xbus master/slave/monitor ... */
  `include "xbus_conf.sv"

  /* xbus tlm transfer */
  `include "xbus_transfer.sv"

  /* xbus monitor to collect the valid trx and dump it to trx.log */
  `include "xbus_dumper.sv"
  `include "xbus_monitor.sv"

  /* xbus master componments */
  `include "xbus_master_driver.sv"
  `include "xbus_master_sequencer.sv"
  `include "xbus_master_agent.sv"

  /* xbus slave componments */
  `include "xbus_slave_driver.sv"
  `include "xbus_slave_sequencer.sv"
  `include "xbus_slave_agent.sv"

endpackage : xbus_pkg

`endif // XBUS_Pkg

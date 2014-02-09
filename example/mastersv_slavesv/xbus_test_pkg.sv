

`ifndef XBUS_TEST_PKG_SV
`define XBUS_TEST_PKG_SV

package xbus_test_pkg;

  // top definition
  `include "xbus_def.sv"

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // xbus componments
  `include "xbus_pkg.sv"
  import xbus_pkg::*;

  // xbus patterns
  `include "xbus_seq_lib_pkg.sv"
  import xbus_seq_lib_pkg::*;

  // suv system tb
  `include "xbus_scoreboard.sv"
  `include "xbus_env.sv"
  `include "xbus_test.sv"

endpackage : xbus_test_pkg

`endif // XBUS_TEST_PKG_SV

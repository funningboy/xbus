

`ifndef XBUS_SEQ_LIB_PKG_SV
`define XBUS_SEQ_LIB_PKG_SV

package xbus_seq_lib_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "xbus_pkg.sv"
  import xbus_pkg::*;

  /* dpi lib */
  `include "xbus_adaptor_dpi_lib.sv"

  /* base seq lib */
  `include "xbus_base_seq_lib.sv"

  /* random test pattern */
  `include "xbus_random_seq_lib.sv"

  /* normal test pattern */
  `include "xbus_normal_seq_lib.sv"

  /* adaptor test pattern */
  `include "xbus_adaptor_seq_lib.sv"

endpackage : xbus_seq_lib_pkg

`endif // XBUS_SEQ_LIB_PKG_SV



/*----------------------------------------------------
// XBUS Conf supports XBUS_Master_Conf, XBUS_Slave_Conf, XBUS_Monitor_Conf
------------------------------------------------------*/

`ifndef XBUS_CONF_SV
`define XBUS_CONF_SV

/*-----------------------------
// XBUS Base Conf ....
------------------------------*/
class xbus_base_conf extends uvm_object;
  bit has_checks = 1;
  bit has_coverage = 1;
  bit has_performance = 1;
  // constrain rules here
  // ....

  // uvm field register
  `uvm_object_utils_begin(xbus_base_conf)
  `uvm_field_int (has_checks, UVM_DEFAULT)
  `uvm_field_int (has_coverage, UVM_DEFAULT)
  `uvm_field_int (has_performance, UVM_DEFAULT)
  `uvm_object_utils_end

  // new
  function new (string name = "xbus_base_conf");
    super.new(name);
  endfunction : new
endclass : xbus_base_conf

/*----------------------------------
// XBUS protocol width/time wait/trx conf ...
-----------------------------------*/
class xbus_conf extends xbus_base_conf;
  // conf all XBUS signals width
  longint C_REQ_WIDTH   = 1;
  longint C_RW_WIDTH    = 1;
  longint C_ADDR_WIDTH  = 14;
  longint C_ACK_WIDTH   = 1;
  longint C_BE_WIDTH    = 4;
  longint C_RDATA_WIDTH = 32;
  longint C_WDATA_WIDTH = 32;

  // it's UVM_PASSIVE(slave) or UVM_ACTIVE(master) mode
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // constrain rules
  constraint CC_REQ_WIDTH   { C_REQ_WIDTH == 1; }
  constraint CC_RW_WIDTH    { C_RW_WIDTH == 1; }
  constraint CC_ADDR_WIDTH  { C_ADDR_WIDTH == 14; }
  constraint CC_ACK_WIDTH   { C_ACK_WIDTH == 1; }
  constraint CC_BE_WIDTH    { C_BE_WIDTH == 4; }
  constraint CC_RDATA_WIDTH { C_RDATA_WIDTH == 32; }
  constraint CC_WDATA_WIDTH { C_WDATA_WIDTH == 32; }

  // uvm field register
  `uvm_object_utils_begin(xbus_conf)
  `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_field_int(C_REQ_WIDTH, UVM_DEFAULT)
  `uvm_field_int(C_RW_WIDTH, UVM_DEFAULT)
  `uvm_field_int(C_ADDR_WIDTH, UVM_DEFAULT)
  `uvm_field_int(C_ACK_WIDTH, UVM_DEFAULT)
  `uvm_field_int(C_BE_WIDTH, UVM_DEFAULT)
  `uvm_field_int(C_RDATA_WIDTH, UVM_DEFAULT)
  `uvm_field_int(C_WDATA_WIDTH, UVM_DEFAULT)
  `uvm_object_utils_end

  // new
  function new (string name = "xbus_conf");
    super.new(name);
  endfunction : new

endclass : xbus_conf

/*-----------------------------------
// XBUS Monitor Conf
------------------------------------*/
class xbus_monitor_conf extends xbus_conf;
  /* hier instance name */
  string name;

  /* req/rsp read wait */
  int unsigned req_rd_wait = 0;
  int unsigned rsp_rd_wait = 0;

  /* req/rsp write wait */
  int unsigned req_wr_wait = 0;
  int unsigned rsp_wr_wait = 0;

  /* at last rsp */
  int unsigned at_last_rsp_wr_wait = 1;
  int unsigned at_last_rsp_rd_wait = 1;

  /* clk period */
  rand longint clk_period = 0;
  rand xbus_type::phy_enum phy_onoff = xbus_type::OFF;

  constraint C_AT_LAST_RSP_WR_WAIT { 1 <= at_last_rsp_wr_wait && at_last_rsp_wr_wait <= 100; }
  constraint C_AT_LAST_RSP_RD_WAIT { 1 <= at_last_rsp_rd_wait && at_last_rsp_rd_wait <= 100; }
  constraint C_REQ_RD_WAIT { 0 <= req_rd_wait && req_rd_wait <= 100; }
  constraint C_RSP_RD_WAIT { 0 <= rsp_rd_wait && rsp_rd_wait <= 100; }
  constraint C_REQ_WR_WAIT { 0 <= req_wr_wait && req_wr_wait <= 100; }
  constraint C_RSP_WR_WAIT { 0 <= rsp_wr_wait && rsp_wr_wait <= 100; }

  `uvm_object_utils_begin(xbus_monitor_conf)
  `uvm_field_string(name, UVM_DEFAULT)
  `uvm_field_int( req_rd_wait, UVM_DEFAULT)
  `uvm_field_int( rsp_rd_wait, UVM_DEFAULT)
  `uvm_field_int( req_wr_wait, UVM_DEFAULT)
  `uvm_field_int( rsp_wr_wait, UVM_DEFAULT)
  `uvm_field_int( at_last_rsp_wr_wait, UVM_DEFAULT)
  `uvm_field_int( at_last_rsp_rd_wait, UVM_DEFAULT)
  `uvm_field_int( clk_period, UVM_DEFAULT)
  `uvm_field_enum( xbus_type::phy_enum, phy_onoff, UVM_DEFAULT)
  `uvm_object_utils_end

  // new
  function new (string name = "xbus_monitor_conf");
    super.new(name);
  endfunction : new

endclass : xbus_monitor_conf

/*------------------------------------
// XBUS Master Conf
-------------------------------------*/
class xbus_master_conf extends xbus_monitor_conf;
  `uvm_object_utils_begin(xbus_master_conf)
  `uvm_object_utils_end

  // new
  function new (string name = "xbus_master_conf");
    super.new(name);
  endfunction : new
endclass : xbus_master_conf

/*-----------------------------------
// XBUS Slave Conf
------------------------------------*/
class xbus_slave_conf extends xbus_monitor_conf;
  `uvm_object_utils_begin(xbus_slave_conf)
  `uvm_object_utils_end

  // new
  function new (string name = "xbus_slave_conf");
    super.new(name);
  endfunction : new
endclass : xbus_slave_conf

`endif // XBUS_CONF_SV




/*----------------------------------------------------
// XBUS Env Master/Slave config and build up
------------------------------------------------------*/

`ifndef XBUS_ENV_SV
`define XBUS_ENV_SV

class xbus_env extends uvm_env;

  /* scoreboard, check the two ways trx between master[0] and slave[0] is correct*/
  xbus_scoreboard m_scoreboard[];

  /* masters */
  xbus_master_agent m_master_agent[];
  xbus_master_conf m_master_conf[];

  /* slaves */
  xbus_slave_agent m_slave_agent[];
  xbus_slave_conf m_slave_conf[];

  // new
  function new (string name = "xbus_env", uvm_component parent);
    super.new(name, parent);
    m_master_agent = new[1]; // 1 master_agents
    m_master_conf = new[1]; // 1 master_confs
    m_slave_agent = new[1]; // 1 slave_agents
    m_slave_conf = new[1]; // 1 slave_confs
    m_scoreboard = new[1]; // 1 master to 1 1 slave
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected function void build_up_master();
  extern virtual protected function void build_up_slave();
  extern virtual protected function void build_up_scoreboard();

endclass : xbus_env

// uvm build phase
function void xbus_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  build_up_master();
  build_up_slave();
  build_up_scoreboard();
endfunction : build_phase

// uvm connect phase
function void xbus_env::connect_phase(uvm_phase phase);
  super.build_phase(phase);
  // connect_master
  // connect_slave
  m_slave_agent[0].m_monitor.item_collected_port.connect(m_scoreboard[0].item_collected_imp);
endfunction : connect_phase

// build up scoreboard
function void xbus_env::build_up_scoreboard();
  m_scoreboard[0] = xbus_scoreboard::type_id::create({$psprintf("m_scoreborard[%0d]", 0)}, this);
endfunction : build_up_scoreboard

// build up masters
function void xbus_env::build_up_master();
  /* master[0] buidup and conf */
  m_master_agent[0] = xbus_master_agent::type_id::create({$psprintf("m_master_agent[%0d]", 0)}, this); //%0d alignment issue
  m_master_conf[0] = xbus_master_conf::type_id::create({$psprintf("m_master_conf[%0d]", 0)}, this);

  // set time wait
  m_master_conf[0].req_wr_wait  = 0;
  m_master_conf[0].req_rd_wait  = 0;
  m_master_conf[0].phy_onoff    = xbus_type::ON;
  m_master_conf[0].clk_period   = `DEF_C_XBUS_CLK_PERIOD;

  // set width
  m_master_conf[0].C_ADDR_WIDTH   = `DEF_ADDR_WIDTH;
  m_master_conf[0].C_BE_WIDTH     = `DEF_BE_WIDTH;
  m_master_conf[0].C_WDATA_WIDTH  = `DEF_WDATA_WIDTH;
  m_master_conf[0].C_RDATA_WIDTH  = `DEF_RDATA_WIDTH;
  m_master_agent[0].assign_conf(m_master_conf[0]);

endfunction : build_up_master

// build up slaves
function void xbus_env::build_up_slave();
  /* slave[0] buildup and conf */
  m_slave_agent[0] = xbus_slave_agent::type_id::create({$psprintf("m_slave_agent[%0d]", 0)}, this);
  m_slave_conf[0] = xbus_slave_conf::type_id::create({$psprintf("m_slave_conf[%0d]", 0)}, this);

  // set time wait
  m_slave_conf[0].rsp_rd_wait   = 2;
  m_slave_conf[0].rsp_wr_wait   = 2;
  m_slave_conf[0].phy_onoff     = xbus_type::ON;
  m_slave_conf[0].clk_period    = `DEF_C_CLK_PERIOD;

  // set width
  m_slave_conf[0].C_ADDR_WIDTH  = `DEF_C_ADDR_WIDTH;
  m_slave_conf[0].C_BE_WIDTH    = `DEF_C_BE_WIDTH;
  m_slave_conf[0].C_WDATA_WIDTH = `DEF_C_WDATA_WIDTH;
  m_slave_conf[0].C_RDATA_WIDTH = `DEF_C_RDATA_WIDTH;
  m_slave_agent[0].assign_conf(m_slave_conf[0]);

endfunction : build_up_slave

`endif // XBUS_ENV_SV


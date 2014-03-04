

/*----------------------------------------------------
// XBUS Master Agent
------------------------------------------------------*/

`ifndef XBUS_MASTER_AGENT_SV
`define XBUS_MASTER_AGENT_SV

class xbus_master_agent extends uvm_agent;
  /* xbus master conf */
  xbus_master_conf m_conf;

  /* xbus vif */
  virtual interface xbus_vif m_vif;

  /* master driver */
  xbus_master_driver m_driver;

  /* master sequencer */
  xbus_master_sequencer m_sequencer;

  /* monitor */
  xbus_monitor m_monitor;

  // uvm field register
  `uvm_component_utils_begin(xbus_master_agent)
  `uvm_component_utils_end

  // new
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern virtual function void assign_conf(xbus_master_conf conf);
  extern virtual function void assign_vif(virtual interface xbus_vif vif);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected function void build_all();
  extern virtual protected function void populate_conf();
  extern virtual protected function void populate_vif();
endclass : xbus_master_agent

// assign conf
function void xbus_master_agent::assign_conf(xbus_master_conf conf);
  assert(conf!=null);
  m_conf = conf;
endfunction : assign_conf

// assign vif
function void xbus_master_agent::assign_vif(virtual interface xbus_vif vif);
  assert(vif!=null);
  m_vif = vif;
endfunction : assign_vif

// build all instances
function void xbus_master_agent::build_all();
  // register all used instances to uvm_factory
  m_monitor = xbus_monitor::type_id::create("m_monitor", this);

  // if it's active mode
  if (m_conf.is_active == UVM_ACTIVE) begin
    m_driver = xbus_master_driver::type_id::create("m_driver", this);
    m_sequencer = xbus_master_sequencer::type_id::create("m_sequencer", this);
  end
endfunction : build_all

// populate conf
function void xbus_master_agent::populate_conf();
  // assign/populate conf
  m_monitor.assign_conf(m_conf);

  if (m_conf.is_active == UVM_ACTIVE) begin
    m_driver.assign_conf(m_conf);
    m_sequencer.assign_conf(m_conf);
  end
endfunction : populate_conf

// populate vif
function void xbus_master_agent::populate_vif();
  // assign/populate vif
  m_monitor.assign_vif(m_vif);

  if (m_conf.is_active == UVM_ACTIVE) begin
    m_driver.assign_vif(m_vif);
    m_sequencer.assign_vif(m_vif);
  end
endfunction : populate_vif

// build phase, populate the conf to it's sub componments (driver,monitor...)
function void xbus_master_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // check conf
  if (m_conf==null)
    `uvm_error("xbus_conf", {$psprintf("conf not set")})
  build_all();
  populate_conf();
endfunction : build_phase

// connect phase, populate the vif to it's sub componments (driver,monitor...)
function void xbus_master_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // check virtual interface

  if (!uvm_config_db#(virtual interface xbus_vif)::get(this, "", "m_vif", m_vif))
    `uvm_error("xbus_vif", {$psprintf("virtual interface not set")})

  populate_vif();
  // connect sequencer if it's an active model
  if (m_conf.is_active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // XBUS_MASTER_AGENT_SV


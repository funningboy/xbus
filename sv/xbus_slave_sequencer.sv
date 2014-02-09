


/*----------------------------------------------------
// XBUS Slave Sequencer
------------------------------------------------------*/

`ifndef XBUS_SLAVE_SEQUENCER_SV
`define XBUS_SLAVE_SEQUENCER_SV

class xbus_slave_sequencer extends uvm_sequencer #(xbus_transfer);

  /* xbus slave conf */
  xbus_slave_conf m_conf;
  /* virtual vif */
  virtual interface xbus_vif m_vif;

  `uvm_component_utils_begin(xbus_slave_sequencer)
  `uvm_component_utils_end

  // new
  function new (string name = "xbus_slave_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (m_conf==null)
    `uvm_error("xbus_conf", {$psprintf("conf not set")})
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // check virtual interface
    if (!uvm_config_db#(virtual interface xbus_vif)::get(this, "", "m_vif", m_vif))
    `uvm_error("xbus_vif", {$psprintf("virtual interface not set")})
  endfunction : connect_phase

  virtual function void assign_vif(virtual interface xbus_vif vif);
    assert(vif!=null);
    m_vif = vif;
  endfunction : assign_vif

  virtual function void assign_conf(xbus_slave_conf conf);
    assert(conf!=null);
    m_conf = conf;
  endfunction : assign_conf

endclass : xbus_slave_sequencer

`endif // XBUS_SLAVE_SEQUENCER_SV

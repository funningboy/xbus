


/*----------------------------------------------------
// XBUS Master Sequencer
------------------------------------------------------*/

`ifndef XBUS_MASTER_SEQUENCER_SV
`define XBUS_MASTER_SEQUENCER_SV

class xbus_master_sequencer extends uvm_sequencer #(xbus_transfer);

  /* xbus master conf */
  xbus_master_conf m_conf;

  /* virtual vif */
  virtual interface xbus_vif m_vif;

  `uvm_component_utils_begin(xbus_master_sequencer)
  `uvm_component_utils_end

  // new
  function new (string name = "xbus_master_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // check conf
    if (m_conf==null)
      `uvm_error("xbus_conf", {$psprintf("conf not set")})
  endfunction : build_phase

  // connect phase
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

  virtual function void assign_conf(xbus_master_conf conf);
    assert(conf!=null);
    m_conf = conf;
  endfunction : assign_conf

endclass : xbus_master_sequencer

`endif // XBUS_MASTER_SEQUENCER_SV



`ifndef XBUS_BASE_SEQ_LIB_SV
`define XBUS_BASE_SEQ_LIB_SV

class xbus_base_seq_lib extends uvm_sequence #(xbus_transfer);

  `uvm_object_utils_begin(xbus_base_seq_lib)
  `uvm_object_utils_end

  // put/hook up xbus_master_sequencer to default sequencer
  //`uvm_declare_p_sequencer(xbus_master_sequencer)
  // new
  function new(string name = "xbus_base_seq_lib");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    //super.build_phase(phase); uvm_sequence not support build_phase, it's a fake method
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    //super.connect_phase(phase); uvm_sequence not support connect_phase, it's a fake method
  endfunction : connect_phase

  // prepare run and lock thread the sequence to sequencer manager
  virtual task pre_body();
    if (starting_phase != null)
    starting_phase.raise_objection(this, {$psprintf("%s running sequencer", get_full_name())});
  endtask : pre_body

  // end of run to release thread by sequencer manager
  virtual task post_body();
    if (starting_phase != null)
    starting_phase.drop_objection(this, {$psprintf("%s completed sequencer", get_full_name())});
  endtask : post_body

endclass : xbus_base_seq_lib

`endif // XBUS_BASE_SEQ_LIB_SV


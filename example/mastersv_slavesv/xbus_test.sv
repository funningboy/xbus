
/*----------------------------------------------------
  testsuite definition
------------------------------------------------------*/

`ifndef XBUS_TEST_SV
`define XBUS_TEST_SV

class xbus_base_test extends uvm_test;

  /* uvm_table printer */
  uvm_table_printer m_printer;

  // uvm field register
  `uvm_component_utils_begin(xbus_base_test)
  `uvm_component_utils_end

  // new
  function new(string name = "xbus_base_test", uvm_component parent);
    super.new(name,parent);
    m_printer = new();
  endfunction : new

  // uvm run phase
  task run_phase(uvm_phase phase);
    m_printer.knobs.depth = 5;
    this.print(m_printer);
    uvm_report_object::set_report_max_quit_count(2);  // set max error quit counts
    phase.phase_done.set_drain_time(this, 1000);      // set the extend $finish time when the all trxs are done
  endtask : run_phase

endclass : xbus_base_test

/*-------------------------------------
// testsuite desceiption here
---------------------------------------*/

/*-------------------------------------------
// TEST: read after write via xbus_normal_rw_seq_lib
--------------------------------------------*/
class test_xbus_normal_rw_seq_lib extends xbus_base_test;

  /* xbus env */
  xbus_env m_xbus_env;

  `uvm_component_utils_begin(test_xbus_normal_rw_seq_lib)
  `uvm_component_utils_end

  function new(string name = "test_xbus_normal_rw_seq_lib", uvm_component parent);
    super.new(name,parent);
  endfunction : new

  // hook up the default sequencer to new sequencer
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    /* build system env */
    m_xbus_env = new("m_xbus_env", this);

    /* turn on uvm transaction recorder */
    set_config_int ("*", "recording_detail", uvm_full);

    uvm_config_db #(uvm_object_wrapper)::set(this, "m_xbus_env.m_master_agent[*0].m_sequencer.run_phase",
    "default_sequence", xbus_normal_rw_seq_lib::type_id::get());

  endfunction : build_phase

endclass : test_xbus_normal_rw_seq_lib


/*-------------------------------------------
// TEST: read after write via xbus_random_rw_seq_lib
--------------------------------------------*/
class test_xbus_random_rw_seq_lib extends xbus_base_test;

  /* xbus env */
  xbus_env m_xbus_env;

  `uvm_component_utils_begin(test_xbus_random_rw_seq_lib)
  `uvm_component_utils_end

  function new(string name = "test_xbus_random_rw_seq_lib", uvm_component parent);
    super.new(name,parent);
  endfunction : new

  // hook up the default sequencer to new sequencer
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    /* build system env */
    m_xbus_env = new("m_xbus_env", this);

    /* turn on uvm transaction recorder */
    set_config_int ("*", "recording_detail", UVM_FULL);

    uvm_config_db #(uvm_object_wrapper)::set(this, "m_xbus_env.m_master_agent[*0].m_sequencer.run_phase",
    "default_sequence", xbus_random_rw_seq_lib::type_id::get());

  endfunction : build_phase

endclass : test_xbus_random_rw_seq_lib


/*-------------------------------------------
// TEST: trx replay via xbus_adaptor_seq_lib
--------------------------------------------*/
class test_xbus_adaptor_seq_lib extends xbus_base_test;

  /* xbus env */
  xbus_env m_xbus_env;

  xbus_adaptor_seq_lib m_adaptor;

  `uvm_component_utils_begin(test_xbus_adaptor_seq_lib)
  `uvm_component_utils_end

  function new(string name = "test_xbus_adaptor_seq_lib", uvm_component parent);
    super.new(name,parent);
  endfunction : new

  // hook up the default sequencer to new sequencer
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    /* build system env */
    m_xbus_env = new("m_xbus_env", this);

    /* turn on uvm transaction recorder */
    set_config_int ("*", "recording_detail", uvm_full);

    /* for master 0 sequencer pattern link */
    xbus_adaptor_seq_lib::assign_file("./pat/00001587.trx");
    uvm_config_db #(uvm_object_wrapper)::set(this, "m_xbus_env.m_master_agent[*0].m_sequencer.run_phase",
    "default_sequence", xbus_adaptor_seq_lib::type_id::get());

  endfunction : build_phase

endclass : test_xbus_adaptor_seq_lib

`endif // XBUS_TEST_SV

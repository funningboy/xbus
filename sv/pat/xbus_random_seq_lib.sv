/*------------------------------------
random pattern test
-------------------------------------*/

`ifndef XBUS_RANDOM_SEQ_LIB_SV
`define XBUS_RANDOM_SEQ_LIB_SV

// random read after write
class xbus_random_rw_seq_lib extends xbus_base_seq_lib;
  xbus_transfer m_trx;
  xbus_master_conf m_conf;
  int unsigned m_wr_id = 0;
  int unsigned m_rd_id = 0;

  `uvm_object_utils_begin(xbus_random_rw_seq_lib)
  `uvm_object_utils_end

  // new
  function new(string name="xbus_random_rw_seq_lib");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // only for uvm_component type support
    // if (!uvm_config_db#(xbus_master_conf)::get(this, "", "m_conf", m_conf))
    // `uvm_error("xbus_conf", {$psprintf("%s conf not set", get_full_name())})
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

  virtual function void assign_conf(xbus_master_conf conf);
    assert(conf!=null);
    m_conf = conf;
  endfunction : assign_conf

  virtual task body();
    `uvm_info(get_type_name(), {$psprintf("starting ... ")}, UVM_MEDIUM)
    sent_write_transfer();
    received_read_transfer();
  endtask : body

  virtual task sent_write_transfer();
    xbus_transfer t_trx = xbus_transfer::type_id::create({$psprintf("m_trx_w[%0d]", m_wr_id)});
    // random
    void'(t_trx.randomize());
    t_trx.rw = xbus_type::WRITE;

    // for next read issue
    $cast(m_trx, t_trx.clone());

    // no wait time, asap to high performae issue
    t_trx.begin_cycle = 0;
    `uvm_info(get_type_name(), {$psprintf("\n%s", t_trx.sprint())}, UVM_LOW)
    start_item(t_trx);
    finish_item(t_trx);
    m_wr_id++;
  endtask : sent_write_transfer

  virtual task received_read_transfer();
    xbus_transfer t_trx = xbus_transfer::type_id::create({$psprintf("m_trx_r[%0d]", m_rd_id)});
    // get the previous write trx info
    $cast(t_trx, m_trx);
    t_trx.rw = xbus_type::READ;
    // no wait time, asap to high performance issue
    t_trx.begin_cycle = 0;
    `uvm_info(get_type_name(), {$psprintf("\n%s", t_trx.sprint())}, UVM_LOW)
    start_item(t_trx);
    finish_item(t_trx);
    m_rd_id++;
  endtask : received_read_transfer

endclass : xbus_random_rw_seq_lib

`endif // XBUS_RANDOM_SEQ_LIB_SV

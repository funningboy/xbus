


`ifndef XBUS_NORMAL_SEQ_LIB_SV
`define XBUS_NORMAL_SEQ_LIB_SV

// Normal 1Read after 1Write
class xbus_normal_rw_seq_lib extends xbus_base_seq_lib;

  xbus_transfer     m_trx;
  xbus_master_conf  m_conf;

  `uvm_object_utils_begin(xbus_normal_rw_seq_lib)
  `uvm_object_utils_end

  // new
  function new(string name="xbus_normal_rw_seq_lib");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // only for uvm_component type support
    // if (!uvm_config_db#(xbus_master_conf)::get(this, "", "m_conf", m_conf))
    // `uvm_error("xbus_conf", {$psprint("%s conf not set", get_full_name())})
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
    xbus_transfer t_trx = xbus_transfer::type_id::create("m_trx_w[0]");
    t_trx.rw    = xbus_type::WRITE;
    t_trx.addr  = 14'h000f;
    t_trx.data  = 32'hffff_ffff;
    t_trx.byten = 4'b0001;
    // no wait time, asap to high performae issue
    t_trx.begin_cycle = 0;
    `uvm_info(get_type_name(), {$psprintf("\n%s", t_trx.sprint())}, UVM_LOW)
    start_item(t_trx);
    finish_item(t_trx);
  endtask : sent_write_transfer

  virtual task received_read_transfer();
    xbus_transfer t_trx = xbus_transfer::type_id::create("m_trx_r[0]");
    t_trx.rw    = xbus_type::READ;
    t_trx.addr  = 14'h000f;
    t_trx.data  = 32'h0000_000f;
    t_trx.byten = 4'b0001;
    // no wait time, asap to high performance issue
    t_trx.begin_cycle = 0;
    `uvm_info(get_type_name(), {$psprintf("\n%s", t_trx.sprint())}, UVM_LOW)
    start_item(t_trx);
    finish_item(t_trx);
  endtask : received_read_transfer

endclass : xbus_normal_rw_seq_lib

`endif // XBUS_NORMAL_SEQ_LIB_SV

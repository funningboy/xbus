

`ifndef XBUS_ADAPTOR_SEQ_LIB_SV
`define XBUS_ADAPTOR_SEQ_LIB_SV

// adaptor
class xbus_adaptor_seq_lib extends xbus_base_seq_lib;

  xbus_transfer     m_trx;
  xbus_master_conf  m_conf;
  int unsigned m_id;
  static string m_file;
  chandle m_dpi_mb;
  chandle m_dpi_trx;

  `uvm_object_utils_begin(xbus_adaptor_seq_lib)
  `uvm_object_utils_end

  // new
  function new(string name="xbus_adaptor_seq_lib");
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

  static function void assign_file(string file);
    m_file = file;
  endfunction : assign_file

  virtual task body();
    `uvm_info(get_type_name(), {$psprintf("starting ... ")}, UVM_MEDIUM)

    m_dpi_mb = dpi_xbus_parse_file(m_file);
    assert(m_dpi_mb!=null);

    m_dpi_trx = dpi_xbus_next_xbus_transfer(m_dpi_mb);
    assert(m_dpi_trx!=null);

    while (m_dpi_trx!=null) begin
      m_trx = xbus_transfer::type_id::create({$psprintf("m_trx[%0d]", m_id)});
      m_trx.begin_cycle = dpi_hexstr_2_longint(dpi_xbus_get_xbus_transfer_begin_cycle(m_dpi_trx));
      m_trx.end_cycle   = dpi_hexstr_2_longint(dpi_xbus_get_xbus_transfer_end_cycle(m_dpi_trx));
      m_trx.begin_time  = dpi_hexstr_2_longint(dpi_xbus_get_xbus_transfer_begin_time(m_dpi_trx));
      m_trx.end_time    = dpi_hexstr_2_longint(dpi_xbus_get_xbus_transfer_end_time(m_dpi_trx));
      m_trx.rw          = ( dpi_xbus_get_xbus_transfer_rw(m_dpi_trx) == "w" ) ?xbus_type::WRITE : xbus_type::READ;
      m_trx.addr        = dpi_hexstr_2_longint(dpi_xbus_get_xbus_transfer_addr(m_dpi_trx));
      m_trx.data        = dpi_hexstr_2_longint(dpi_xbus_get_xbus_transfer_data(m_dpi_trx));
      m_trx.byten       = dpi_hexstr_2_longint(dpi_xbus_get_xbus_transfer_byten(m_dpi_trx));

      `uvm_info(get_type_name(), {$psprintf("\n%s", m_trx.sprint())}, UVM_LOW)
      start_item(m_trx);
      finish_item(m_trx);

      m_dpi_trx = dpi_xbus_next_xbus_transfer(m_dpi_mb);
  end

  endtask : body

endclass : xbus_adaptor_seq_lib

`endif // XBUS_ADAPTOR_SEQ_LIB_SV

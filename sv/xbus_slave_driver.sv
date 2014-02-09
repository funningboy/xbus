

/*----------------------------------------------------
// XBUS Slave Driver
------------------------------------------------------*/
`ifndef XBUS_SLAVE_DRIVER_SV
`define XBUS_SLAVE_DRIVER_SV

class xbus_slave_driver extends uvm_driver #(xbus_transfer);
  /* slave conf */
  xbus_slave_conf m_conf;

  /* xbus vif */
  virtual interface xbus_vif m_vif;

  /* xbus trx count */
  longint m_trx_num;

  /*xbus transfer queue*/
  xbus_transfer m_trx_queue[$];

  /*xbus transfer*/
  xbus_transfer m_trx;

  /* xbus slave internal memory */
  int unsigned m_mem[int unsigned];

  `uvm_component_utils_begin(xbus_slave_driver)
  `uvm_component_utils_end

  // new
  function new (string name = "xbus_slave_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  /* assign conf vif */
  extern virtual function void assign_vif(virtual interface xbus_vif vif);
  extern virtual function void assign_conf(xbus_slave_conf conf);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

  extern virtual protected task reset_signals();
  //extern virtual protected task drive_transfer(xbus_transfer trx);
  extern virtual protected task received_transfer();
  extern virtual protected task response_write_transfer();
  extern virtual protected task response_read_transfer();
  extern virtual protected task populate_write_transfer();
  extern virtual protected task populate_read_transfer();
  extern virtual protected task release_transfer();

endclass : xbus_slave_driver

//assign conf
function void xbus_slave_driver::assign_conf(xbus_slave_conf conf);
  assert(conf!=null);
  m_conf = conf;
endfunction : assign_conf

//assign vif
function void xbus_slave_driver::assign_vif(virtual interface xbus_vif vif);
  assert(vif!=null);
  m_vif = vif;
endfunction : assign_vif

// uvm build phase
function void xbus_slave_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // check conf
  if (m_conf==null)
    `uvm_error("xbus_conf", {$psprintf("conf not set")})
endfunction : build_phase

// uvm connect phase
function void xbus_slave_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // check virtual interface
  if (!uvm_config_db#(virtual interface xbus_vif)::get(this, "", "m_vif", m_vif))
    `uvm_error("xbus_vif", {$psprintf("virtual interface not set")})
endfunction : connect_phase

// uvm run phase
task xbus_slave_driver::run_phase(uvm_phase phase);
  fork
    reset_signals();
    received_transfer();
  join
endtask : run_phase

// rset all signals when the rst happened
task xbus_slave_driver::reset_signals();
  // do reset all signals when the rst happened
  m_vif.slave.ack = 1'b0;
endtask : reset_signals

// received trasnfer
task xbus_slave_driver::received_transfer();
  forever begin
    @(posedge m_vif.slave.local_clk iff m_vif.slave.req === 1'b1);

    if (m_vif.slave.rw == 1'b1)
      response_write_transfer();
    else
      response_read_transfer();

    // at last one holding cycle to response back
    @(posedge m_vif.slave.local_clk);

    // release rsp trx
    release_transfer();

    // at last one holding cycle to detect the next trx happend
    @(posedge m_vif.slave.local_clk);
  end
endtask :received_transfer

// response write transfer
task xbus_slave_driver::response_write_transfer();
  repeat($urandom_range(m_conf.rsp_wr_wait, 0)) @(posedge m_vif.slave.local_clk);
  populate_write_transfer();
endtask : response_write_transfer

// populate write transfer
task xbus_slave_driver::populate_write_transfer();
  int unsigned byten_data = 0;

  // byten_data
  foreach (m_vif.slave.be[i]) begin
    byten_data = byten_data + (2 ** 8 ** (i)) * m_vif.slave.be[i] * 255;
  end

  // check the write mem address has existed or not, if it has exsited, then update it's data via and comparing operator
  if (!m_mem.exists(m_vif.slave.addr))
    m_mem[m_vif.slave.addr] = (m_vif.slave.wdata & byten_data);
  else
    m_mem[m_vif.slave.addr] = m_mem[m_vif.slave.addr] | (m_vif.slave.wdata & byten_data);

  `uvm_info(get_type_name(), {$psprintf("stored addr %h, data %h, byten %h, byten_data %h, stored_data %h",
  m_vif.slave.addr, m_vif.slave.wdata, m_vif.slave.be, byten_data, m_vif.slave.wdata & byten_data)}, UVM_LOW)

  if (m_conf.phy_onoff == xbus_type::ON)
    #(m_conf.clk_period/2);

  m_vif.slave.ack = 1'b1;
endtask : populate_write_transfer

// response read transfer
task xbus_slave_driver::response_read_transfer();
  repeat($urandom_range(m_conf.rsp_rd_wait, 0)) @(posedge m_vif.slave.local_clk);
  populate_read_transfer();
endtask : response_read_transfer

// populate read transfer
task xbus_slave_driver::populate_read_transfer();
  int unsigned byten_data = 0;

  // byten_data
  foreach (m_vif.slave.be[i]) begin
    byten_data = byten_data + (2 ** 8 ** (i)) * m_vif.slave.be[i] * 255;
  end

  m_vif.slave.rdata = m_mem[m_vif.slave.addr] & byten_data;

  `uvm_info(get_type_name(), {$psprintf("read addr %h, data %h", m_vif.slave.addr, m_vif.slave.rdata)}, UVM_LOW)

  if (m_conf.phy_onoff == xbus_type::ON)
    #(m_conf.clk_period/2);

  m_vif.slave.ack = 1'b1;
endtask : populate_read_transfer

// release transfer
task xbus_slave_driver::release_transfer();
  if (m_conf.phy_onoff == xbus_type::ON)
    #(m_conf.clk_period/2);

  m_vif.slave.ack = 1'b0;
endtask : release_transfer

`endif // XBUS_SLAVE_DRIVER_SV


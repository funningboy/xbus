

/*----------------------------------------------------
// XBUS Master Driver
------------------------------------------------------*/
`ifndef XBUS_MASTER_DRIVER_SV
`define XBUS_MASTER_DRIVER_SV

class xbus_master_driver extends uvm_driver #(xbus_transfer);
  /* master conf */
  xbus_master_conf m_conf;

  /* xbus vif */
  virtual interface xbus_vif m_vif;

  /* xbus trx count */
  longint m_trx_num;

  /*xbus transfer queue*/
  xbus_transfer m_trx_queue[$];

  /*xbus transfer*/
  xbus_transfer m_trx;

  /*xbus cycle count */
  longint m_cycle = 0;

  `uvm_component_utils_begin(xbus_master_driver)
  `uvm_component_utils_end

  // new
  function new (string name = "xbus_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  /* assign conf vif */
  extern virtual function void assign_vif(virtual interface xbus_vif vif);
  extern virtual function void assign_conf(xbus_master_conf conf);
  /* uvm phase */
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset_signals();
  extern virtual protected function void drive_transfer(xbus_transfer trx);
  extern virtual protected task fetch_trx_from_sequencer();
  extern virtual protected task send_transfer();
  extern virtual protected task populate_write_transfer();
  extern virtual protected task populate_read_transfer();
  extern virtual protected task release_transfer();
  extern virtual protected task collect_cycle_count();
endclass : xbus_master_driver

//assign conf
function void xbus_master_driver::assign_conf(xbus_master_conf conf);
  assert(conf!=null);
  m_conf = conf;
endfunction : assign_conf

//assign vif
function void xbus_master_driver::assign_vif(virtual interface xbus_vif vif);
  assert(vif!=null);
  m_vif = vif;
endfunction : assign_vif

// uvm build phase
function void xbus_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // check conf
  if (m_conf==null)
    `uvm_error("xbus_conf", {$psprintf("conf not set")})
endfunction : build_phase

// uvm connect phase
function void xbus_master_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // check virtual interface
  if (!uvm_config_db#(virtual interface xbus_vif)::get(this, "", "m_vif", m_vif))
    `uvm_error("xbus_vif", {$psprintf("virtual interface not set")})
endfunction : connect_phase

// uvm run phase
task xbus_master_driver::run_phase(uvm_phase phase);
  fork
    get_and_drive(); // get trx from sequencer and drive this trx to vif
    reset_signals();
    send_transfer();
    collect_cycle_count();
  join
endtask : run_phase

// fetch trx from trx sequencer and then put this trx to vif
task xbus_master_driver::get_and_drive();
  // wait for reset ...
  fetch_trx_from_sequencer();
endtask : get_and_drive

// rset all signals when the rst happened
task xbus_master_driver::reset_signals();
  // do reset all signals when the rst happened
  m_vif.master.req = 1'b0;
endtask : reset_signals

// fetch trx from sequencer and put the trx to trx queue
task xbus_master_driver::fetch_trx_from_sequencer();
  xbus_transfer t_trx;
  forever begin
    @(posedge m_vif.master.local_clk);
    seq_item_port.get_next_item(req);
    $cast(t_trx, req.clone());
    drive_transfer(t_trx);
    seq_item_port.item_done();
  end
endtask : fetch_trx_from_sequencer

// drive_transfer
function void xbus_master_driver::drive_transfer(xbus_transfer trx);
  `uvm_info(get_type_name(), {$psprintf("\n%s", trx.sprint())}, UVM_LOW)
  m_trx_queue.push_back(trx);
  m_trx_num++;
endfunction : drive_transfer

// send trasnfer
task xbus_master_driver::send_transfer();
  forever begin
    // req time wait
    repeat($urandom_range(0, (m_conf.req_wr_wait + m_conf.req_rd_wait)/2)) @(posedge m_vif.master.local_clk);

    // check the trx is already to send or not
    @(posedge m_vif.master.local_clk iff m_trx_queue.size() != 0);

    $cast(m_trx, m_trx_queue[0]);
    // check the trx start cycle is already to send or not
    repeat(m_trx.begin_cycle > m_cycle) @(posedge m_vif.master.local_clk);

    if (m_trx.rw == 1'b1)
      populate_write_transfer();
    else
      populate_read_transfer();

    // at last holding one cycle for handshake issue no combinational feedback
    //@(posedge m_vif.master.local_clk);

    @(posedge m_vif.master.local_clk iff m_vif.master.ack == 1'b1);
    release_transfer();

    m_trx_queue.delete(0);

    // at last one holding cycle for handshake issue
    @(posedge m_vif.master.local_clk);
  end
endtask : send_transfer

// populate write transfer
task xbus_master_driver::populate_write_transfer();
  `uvm_info(get_type_name(), {$psprintf("%s", m_trx.sprint())}, UVM_LOW)

  if (m_conf.phy_onoff == xbus_type::ON)
    #(m_conf.clk_period/2);

  m_vif.master.req    = 1'b1;
  m_vif.master.rw     = 1'b1;
  m_vif.master.addr   = m_trx.addr;
  m_vif.master.be     = m_trx.byten;
  m_vif.master.wdata  = m_trx.data;
endtask : populate_write_transfer

  // populate read transfer
task xbus_master_driver::populate_read_transfer();
  `uvm_info(get_type_name(), {$psprintf("%s", m_trx.sprint())}, UVM_LOW)

  if (m_conf.phy_onoff == xbus_type::on)
    #(m_conf.clk_period/2);

  m_vif.master.req  = 1'b1;
  m_vif.master.rw   = 1'b0;
  m_vif.master.addr = m_trx.addr;
  m_vif.master.be   = m_trx.byten;
endtask : populate_read_transfer

// release transfer
task xbus_master_driver::release_transfer();
  if (m_conf.phy_onoff == xbus_type::on)
    #(m_conf.clk_period/2);

  m_vif.master.req = 1'b0;
endtask : release_transfer

// inc cycle count
task xbus_master_driver::collect_cycle_count();
  forever begin
    @(posedge m_vif.master.local_clk);
    m_cycle += 1;
  end
endtask : collect_cycle_count

`endif // XBUS_MASTER_DRIVER_SV


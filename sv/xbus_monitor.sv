
/*----------------------------------------------------
// XBUS monitor
------------------------------------------------------*/

`ifndef XBUS_MONITOR_SV
`define XBUS_MONITOR_SV

class xbus_monitor extends xbus_dumper;

  /* xbus virtual vif */
  virtual interface xbus_vif m_vif;

  /* xbus monitor conf */
  xbus_monitor_conf m_conf;

  /* cycle count */
  longint m_cycle = 0;

  /* collected xbus trx */
  protected xbus_transfer m_trx;

  /* trx id */
  longint m_rd_id = 0;
  longint m_wr_id = 0;

  /* trx wait */
  longint m_rd_wait = 0;
  longint m_wr_wait = 0;

  /* r/w type */
  xbus_type::rw_enum m_rw_type;

  /*trx count*/
  int unsigned m_trx_count = 0;

  /*trx done event*/
  event m_trx_done;

  /* tlm analysis port to dumper/scoreboard or third part golden model(c/systemc) */
  uvm_analysis_port #(xbus_transfer) item_collected_port;

  /*------------------------------
  // covergroup for tlb protocol
  // please write your functional coverage rules here
  -------------------------------*/
  covergroup xbus_transfer_cg;
    xbus_addr : coverpoint m_trx.addr {
    bins zero = {0};
    bins non_zero = {[1:32'hffff_ffff]};
    }
    xbus_rw : coverpoint m_trx.rw {
    bins read = {xbus_type::READ};
    bins write = {xbus_type::WRITE};
    }
    xbus_data : coverpoint m_trx.data {
    bins zero = {0};
    bins non_zero = {[1:32'hffff_ffff]};
    }
    xbus_byten : coverpoint m_trx.byten {
    bins zero = {0};
    bins non_zero = {[1:4'b1111]};
    }
    // example for extend(speical) mem table issue, you can reimplement it in your monitor class
    xbus_extend_addr : coverpoint m_trx.addr {
    bins zero = {0};
    bins addr_0 = {32'h0000_000f};
    bins addr_1 = {32'h000f_000f};
    }
    xbus_extend_byten : coverpoint m_trx.byten {
    bins zero = {0};
    bins byten_0000 = {4'b0000};
    bins byten_0001 = {4'b0001};
    bins byten_1111 = {4'b1111};
    }
    /*
    xbus_bandwidth : coverpoint (m_trx.end_cycle - m_trx.begin_cycle) {
    bins zero = {0};
    bins slow = {[7:20]};
    bins normal = {[4:6]};
    bins fast = {[1:3]};
    }
    */
    xbus_write_trx  : cross xbus_addr, xbus_rw, xbus_data, xbus_byten;
    xbus_read_trx   : cross xbus_addr, xbus_rw;
    xbus_extend_trx : cross xbus_extend_addr, xbus_rw, xbus_data, xbus_extend_byten;
    // xbus_bandwidth_write_trx : cross xbus_addr, xbus_rw, xbus_data, xbus_byten, xbus_bandwidth
  endgroup : xbus_transfer_cg

  // uvm field register
  `uvm_component_utils_begin(xbus_monitor)
  `uvm_component_utils_end

  // new
  function new (string name = "xbus_monitor", uvm_component parent);
    super.new(name, parent);

    // create covergroup
    xbus_transfer_cg = new();

    // create tlm port
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  /* assign ibl virtual interface */
  extern virtual function void assign_vif(virtual xbus_vif vif);
  /* assign xbus monitor conf */
  extern virtual function void assign_conf(xbus_monitor_conf conf);
  /* uvm phase */
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
  /* collect transfer */
  extern virtual protected task collect_write_transfer();
  extern virtual protected task collect_read_transfer();
  /* try collect transfer */
  extern virtual protected task try_collect_write_transfer();
  extern virtual protected task try_collect_read_transfer();
  /* populate transfer */
  extern virtual protected function void populate_write_begin_transfer();
  extern virtual protected function void populate_write_end_transfer();
  extern virtual protected function void populate_read_begin_transfer();
  extern virtual protected function void populate_read_end_transfer();
  /* compare transfer */
  extern virtual protected function void compare_write_transfer();
  extern virtual protected function void compare_read_transfer();
  /* do checks */
  extern virtual protected task do_write_checks();
  extern virtual protected task do_read_checks();
  /* do perfromance */
  extern virtual protected task do_write_performace();
  extern virtual protected task do_read_performance();
  /* collect cycle */
  extern virtual protected task collect_cycle_count();

endclass : xbus_monitor

// assign vif from top set
function void xbus_monitor::assign_vif(virtual interface xbus_vif vif);
  assert(vif!=null);
  m_vif = vif;
endfunction : assign_vif

// assign conf from top set
function void xbus_monitor::assign_conf(xbus_monitor_conf conf);
  assert(conf!=null);
  m_conf = conf;
endfunction : assign_conf

// uvm build phase
function void xbus_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // check conf
  if (m_conf==null)
    `uvm_error("xbus_conf", {$psprintf("conf not set")})
  // callback to dumper
  do_header_dump(get_type_name());
  // trx pool to store the r/w trx
  m_trx = xbus_transfer::type_id::create("m_trx", this);
endfunction : build_phase

// uvm connect phase
function void xbus_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase); // call parent's connect phase first....
  // check virtual interface
  if (!uvm_config_db#(virtual interface xbus_vif)::get(this, "", "m_vif", m_vif))
    `uvm_error("xbus_vif", {$psprintf("virtual interface not set")})
endfunction : connect_phase

// uvm report phase
function void xbus_monitor::report_phase(uvm_phase phase);
  super.report_phase(phase);
  `uvm_info(get_type_name(), {$psprintf("found %d trxs", m_trx_count)}, UVM_HIGH)
endfunction : report_phase

// uvm run phase
task xbus_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
  fork
    collect_cycle_count();
    collect_write_transfer();
    collect_read_transfer();
  join
endtask : run_phase

// inc cycle count
task xbus_monitor::collect_cycle_count();
  forever begin
  @(posedge m_vif.local_clk);
  m_cycle += 1;
end
endtask : collect_cycle_count

// collect write transfer
task xbus_monitor::collect_write_transfer();
  fork
    try_collect_write_transfer();
    // trx/perf check...
    if (m_conf.has_checks)
      do_write_checks();
    if (m_conf.has_performance)
      do_write_performace();
  join
endtask : collect_write_transfer

// collect read transfer
task xbus_monitor::collect_read_transfer();
  fork
    try_collect_read_transfer();
    // trx/perf check...
    if (m_conf.has_checks)
      do_read_checks();
    if (m_conf.has_performance)
      do_read_performance();
  join
endtask : collect_read_transfer

// try collect write transfer
task xbus_monitor::try_collect_write_transfer();
  forever begin
    @(posedge m_vif.local_clk iff (m_vif.req === 1'b1 && m_vif.rw === 1'b1 ));

    // populate write cycle info to write trx info
    populate_write_begin_transfer();

    // wait until the ack is back
    while ( m_vif.ack != 1'b1 ) begin
      compare_write_transfer();
      @(posedge m_vif.local_clk);
    end

    populate_write_end_transfer();

    // to tlm analysis port
    item_collected_port.write(m_trx);

    //callback to dumper
    do_write_dump(m_trx);
    m_trx_count++;

    // notify trx done event
    ->m_trx_done;

    // at last one wait cycle
    @(posedge m_vif.local_clk);
  end
endtask : try_collect_write_transfer

// populate write begin transfer as "begin_trx(trx)"
function void xbus_monitor::populate_write_begin_transfer();
  m_rw_type   = xbus_type::WRITE;
  m_trx.rw    = xbus_type::WRITE;
  m_trx.addr  = m_vif.addr;
  m_trx.data  = m_vif.wdata;
  m_trx.byten = m_vif.be;
  m_trx.id    = m_wr_id;
  m_trx.begin_time = $time;
  m_trx.begin_cycle = m_cycle;
  void'(this.begin_tr(m_trx));
  m_wr_id++;
  m_wr_wait = 0;
endfunction : populate_write_begin_transfer

  // populate write end transfer as "end_trx(trx)"
function void xbus_monitor::populate_write_end_transfer();
  m_trx.end_time  = $time;
  m_trx.end_cycle = m_cycle;
  void'(this.end_tr(m_trx));
endfunction : populate_write_end_transfer

// compare the write transfer is in a consist value in it's waiting phase...
function void xbus_monitor::compare_write_transfer();
  bit rst = m_trx.rw == xbus_type::WRITE &&
  m_trx.addr == m_vif.addr &&
  m_trx.data == m_vif.wdata &&
  m_trx.byten == m_vif.be;
  m_wr_wait++;
  // check the values are consist
  if (!rst)
    `uvm_error("xbus_protocol", {$psprintf("the write transfer is inconsist in it's waiting phase %s\n", m_trx.sprint())})
  // check the ack has arrived
  if (m_wr_wait > m_conf.at_last_rsp_wr_wait)
    `uvm_warning("xbus_protocol", {$psprintf("the ack is outof time %d in it's write transfer ", m_wr_wait)})

endfunction : compare_write_transfer

// try collect read transfer
task xbus_monitor::try_collect_read_transfer();
  forever begin
    @(posedge m_vif.local_clk iff (m_vif.req === 1'b1 && m_vif.rw === 1'b0 ));

    // populate read cycle info to read trx info
    populate_read_begin_transfer();

    // wait until the ack is back
    while (m_vif.ack != 1'b1) begin
      compare_read_transfer();
      @(posedge m_vif.local_clk);
    end

    populate_read_end_transfer();

    // to tlm analysis port
    item_collected_port.write(m_trx);

    // callback to dumper
    do_read_dump(m_trx);
    m_trx_count++;

    // notify trx done event
    ->m_trx_done;

    // at last one cycle wait
    @(posedge m_vif.local_clk);
  end
endtask : try_collect_read_transfer

// populate read begin transfer
function void xbus_monitor::populate_read_begin_transfer();
  m_rw_type   = xbus_type::READ;
  m_trx.rw    = xbus_type::READ;
  m_trx.addr  = m_vif.addr;
  m_trx.byten = m_vif.be;
  m_trx.id    = m_rd_id;
  m_trx.begin_time = $time;
  m_trx.begin_cycle = m_cycle;
  void'(this.begin_tr(m_trx));
  m_rd_id++;
  m_rd_wait = 0;
endfunction : populate_read_begin_transfer

  // populate read end transfer
function void xbus_monitor::populate_read_end_transfer();
  m_trx.data= m_vif.rdata;
  m_trx.end_time = $time;
  m_trx.end_cycle = m_cycle;
  void'(this.end_tr(m_trx));
endfunction : populate_read_end_transfer

  // compare the read transfer is in a consist value it it's waiting phase ...
function void xbus_monitor::compare_read_transfer();
  bit rst = m_trx.rw == xbus_type::READ &&
  m_trx.addr == m_vif.addr &&
  m_trx.byten == m_vif.be;
  m_rd_wait++;
  if (!rst)
    `uvm_error("xbus_protocol", {$psprintf("the read transfer is inconsist in it's waiting \n%s", m_trx.sprint())})
  if (m_rd_wait > m_conf.at_last_rsp_rd_wait)
    `uvm_warning("xbus_protocol", {$psprintf("the ack is outof time %d in it's read transfer ", m_rd_wait)})
endfunction : compare_read_transfer

task xbus_monitor::do_write_checks();
//... checks
endtask : do_write_checks

task xbus_monitor::do_write_performace();
  forever begin
    @(m_trx_done);
    // ... performance
    // functional coverage sample
    xbus_transfer_cg.sample();
  end
endtask : do_write_performace

task xbus_monitor::do_read_checks();
//... checks
endtask : do_read_checks

task xbus_monitor::do_read_performance();
  forever begin
    @(m_trx_done);
    //... performance
    // functional coverage sample
    xbus_transfer_cg.sample();
  end
endtask : do_read_performance

`endif // XBUS_MONITOR_SV

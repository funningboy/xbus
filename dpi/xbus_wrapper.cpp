
#include "xbus_wrapper.h"

/* shared lib build up */
#ifdef __cplusplus
extern "C" {

  /* char str to long int */
  long int dpi_hexstr_2_longint(char* st) {
    std::stringstream ss;
    unsigned long x;
    ss << std::hex << st;
    ss >> x;
    return x;
  }
  /* longint 2 str */
  char* dpi_longint_2_hexstr(long int i){
    std::stringstream ss;
    string x;
    ss << std::hex << i;
    ss >> x;
    return const_cast<char*>(x.c_str());
  }
  /* new XBUS_Transfer */
  void* dpi_xbus_new_xbus_transfer() {
    XBUS_Transfer* tt = new XBUS_Transfer();
    assert(tt!=NULL && "UVM_ERROR: DPI_XBUS, new XBUS_Transfer fail");
    return reinterpret_cast<void*>(tt);
  }
  /* new XBUS_MailBox */
  void* dpi_xbus_new_xbus_maxbusox(char* inst_name) {
    XBUS_MailBox* ft = new XBUS_MailBox(inst_name);
    assert(ft!=NULL && "UVM_ERROR: DPI_XBUS, new XBUS_MailBox fail");
    return reinterpret_cast<void*>(ft);
  }
  /* set begin time */
  void dpi_xbus_set_xbus_transfer_begin_time(void* ip, char* begin_time) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR: DPI_XBUS, set XBUS_Transfer begin_time fail");
    tt->begin_time = dpi_hexstr_2_longint(begin_time);
  }
  /* get begin time */
  char* dpi_xbus_get_xbus_transfer_begin_time(void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR: DPI_XBUS, get XBUS_Transfer begin_time fail");
    return dpi_longint_2_hexstr(tt->begin_time);
  }
  /* set end time */
  void dpi_xbus_set_xbus_transfer_end_time(void* ip, char* end_time) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR: DPI_XBUS, set XBUS_Transfer end_time fail");
    tt->end_time = dpi_hexstr_2_longint(end_time);
  }
  /* get end time */
  char* dpi_xbus_get_xbus_transfer_end_time(void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERRORL DPI_XBUS, get_XBUS_Transfer end time fail");
    return dpi_longint_2_hexstr(tt->end_time);
  }
  /* set begin_cycle */
  void dpi_xbus_set_xbus_transfer_begin_cycle(void* ip, char* begin_cycle) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, set_XBUS_Transfer begin cycle fail");
    tt->begin_cycle = dpi_hexstr_2_longint(begin_cycle);
  }
  /* get begin cycle */
  char* dpi_xbus_get_xbus_transfer_begin_cycle(void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, get_XBUS_Transfer begin cycle fail");
    return dpi_longint_2_hexstr(tt->begin_cycle);
  }
  /* set end_cycle */
  void dpi_xbus_set_xbus_transfer_end_cycle(void* ip, char* end_cycle) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, set_XBUS_Transfer end cycle fail");
    tt->end_cycle = dpi_hexstr_2_longint(end_cycle);
  }
  /* get end cycle */
  char* dpi_xbus_get_xbus_transfer_end_cycle(void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, get_XBUS_Transfer end cycle fail");
    return dpi_longint_2_hexstr(tt->end_cycle);
  }
  /* set rw */
  void dpi_xbus_set_xbus_transfer_rw(void* ip, char* rw) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, set_XBUS_Transfer rw fail");
    tt->rw = rw;
  }
  /* get rw */
  char* dpi_xbus_get_xbus_transfer_rw(void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, get_XBUS_Transfer rw fail");
    char *cstr = new char[tt->rw.length() + 1];
    strcpy(cstr, tt->rw.c_str());
    return cstr;
  }
  /* set addr */
  void dpi_xbus_set_xbus_transfer_addr(void* ip, char* addr) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, set_XBUS_Transfer addr fail");
    tt->addr = dpi_hexstr_2_longint(addr);
  }
  /* get addr */
  char* dpi_xbus_get_xbus_transfer_addr(void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, get_XBUS_Transfer addr fail");
    return dpi_longint_2_hexstr(tt->addr);
  }
  /* set data */
  void dpi_xbus_set_xbus_transfer_data(void* ip, char* data) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, set_XBUS_Transfer data fail");
    tt->data = dpi_hexstr_2_longint(data);
  }
  /* get data */
  char* dpi_xbus_get_xbus_transfer_data(void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, get_XBUS_Transfer data fail");
    return dpi_longint_2_hexstr(tt->data);
  }
  /* set byten */
  void dpi_xbus_set_xbus_transfer_byten(void* ip, char* data) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, set_XBUS_Transfer byten fail");
    tt->byten = dpi_hexstr_2_longint(data);
  }
  /* get byten */
  char* dpi_xbus_get_xbus_transfer_byten(void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_XBUS, get_XBUS_Transfer byten fail");
    return dpi_longint_2_hexstr(tt->byten);
  }
  /* dpi register xbus transfer 2 xbus maxbusox */
  void dpi_xbus_register_xbus_transfer(void* it, void* ip) {
    XBUS_Transfer* tt = reinterpret_cast<XBUS_Transfer*>(ip);
    XBUS_MailBox* ft = reinterpret_cast<XBUS_MailBox*>(it);
    assert(tt!=NULL && ft!=NULL && "UVM_ERROR: DPI_XBUS, register XBUS_Transfer is fail");
    ft->push(tt);
  }
  /* dpi get xbus_transfer if the maxbusox queue is not empty */
  void* dpi_xbus_next_xbus_transfer(void* it) {
    XBUS_MailBox* ft = reinterpret_cast<XBUS_MailBox*>(it);
    assert(ft!=NULL && "UVM_ERROR: DPI_XBUS, next XBUS_Transfer is fial");
    XBUS_Transfer* tt = ft->next();
    return reinterpret_cast<void*>(tt);
  }

}
#endif




#include <iostream>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "xbus_transfer.h"

using namespace std;
using namespace XBUS;

#ifdef __cplusplus
extern "C" {
  long int dpi_str_2_longint(char* st);
  char* dpi_longint_2_str(long int i);
  void* dpi_xbus_parse_file(char* file);
  void* dpi_xbus_new_xbus_transfer();
  void* dpi_xbus_new_xbus_maxbusox(char* inst_name);
  /* begin cycle */
  void dpi_xbus_set_xbus_transfer_begin_cycle(void* ip, char* begin_cycle);
  char* dpi_xbus_get_xbus_transfer_begin_cycle(void* ip);
  /* end cycle */
  void dpi_xbus_set_xbus_transfer_end_cycle(void* ip, char* end_cycle);
  char* dpi_xbus_get_xbus_transfer_end_cycle(void* ip);
  /* begin_time */
  void dpi_xbus_set_xbus_transfer_begin_time(void* ip, char* begin_time);
  char* dpi_xbus_get_xbus_transfer_begin_time(void* ip);
  /* end_time */
  void dpi_xbus_set_xbus_transfer_end_time(void* ip, char* end_time);
  char* dpi_xbus_get_xbus_transfer_end_time(void* ip);
  /* rw */
  void dpi_xbus_set_xbus_transfer_rw(void* ip, char* rw);
  char* dpi_xbus_get_xbus_transfer_rw(void* ip);
  /* addr */
  void dpi_xbus_set_xbus_transfer_addr(void* ip, char* addr);
  char* dpi_xbus_get_xbus_transfer_addr(void* ip);
  /* data */
  void dpi_xbus_set_xbus_transfer_data(void* ip, char* data);
  char* dpi_xbus_get_xbus_transfer_data(void* ip);
  /* byten */
  void dpi_xbus_set_xbus_transfer_byten(void* ip, char* byten);
  char* dpi_xbus_get_xbus_transfer_byten(void* ip);
  /* register xbus trx to xbus maxbusox */
  void dpi_xbus_register_xbus_transfer(void* it, void* ip);
  /* get nxt xbus trx */
  void* dpi_xbus_next_xbus_transfer(void* it);
}
#endif

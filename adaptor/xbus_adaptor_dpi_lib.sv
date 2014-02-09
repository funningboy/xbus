

/* util */
import "DPI" function longint dpi_hexstr_2_longint(string st);
import "DPI" function string dpi_longint_2_hexstr(longint i);

/* XBUS util calls */
import "DPI" function chandle dpi_xbus_parse_file(string name);
import "DPI" function chandle dpi_xbus_next_xbus_transfer(chandle mb);

/* XBUS set function calls */
import "DPI" function string dpi_xbus_set_xbus_transfer_begin_cycle(chandle trx, string begin_cycle);
import "DPI" function string dpi_xbus_set_xbus_transfer_end_cycle(chandle trx, string end_cycle);
import "DPI" function string dpi_xbus_set_xbus_transfer_begin_time(chandle trx, string begin_time);
import "DPI" function string dpi_xbus_set_xbus_transfer_end_time(chandle trx, string end_time);
import "DPI" function string dpi_xbus_set_xbus_transfer_rw(chandle trx, string rw);
import "DPI" function string dpi_xbus_set_xbus_transfer_addr(chandle trx, string addr);
import "DPI" function string dpi_xbus_set_xbus_transfer_data(chandle trx, string data);
import "DPI" function string dpi_xbus_set_xbus_transfer_byten(chandle trx, string byten);


/* XBUS get function calls */
import "DPI" function string dpi_xbus_get_xbus_transfer_begin_cycle(chandle trx);
import "DPI" function string dpi_xbus_get_xbus_transfer_end_cycle(chandle trx);
import "DPI" function string dpi_xbus_get_xbus_transfer_begin_time(chandle trx);
import "DPI" function string dpi_xbus_get_xbus_transfer_end_time(chandle trx);
import "DPI" function string dpi_xbus_get_xbus_transfer_rw(chandle trx);
import "DPI" function string dpi_xbus_get_xbus_transfer_addr(chandle trx);
import "DPI" function string dpi_xbus_get_xbus_transfer_data(chandle trx);
import "DPI" function string dpi_xbus_get_xbus_transfer_byten(chandle trx);



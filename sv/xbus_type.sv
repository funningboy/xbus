

// for type define
class xbus_type extends uvm_object;

  /* RW enum */
  typedef enum { READ = 0, WRITE = 1 } rw_enum;

  /*PHYSICAL enum*/
  typedef enum { ON =1, OFF = 0 } phy_enum;

endclass : xbus_Type

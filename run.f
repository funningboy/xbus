-uvm
-64bit
-access rwc
-status
./example/mastersv_slavesv/xbus_top.sv
-top top
+UVM_TESTNAME=test_xbus_adaptor_seq_lib
+UVM_VERBOSITY=UVM_FULL
-covoverwrite
-coverage b:u
+nccoverage+functional
+notchkmsg
+notimingchecks
+no_notifier
+define+SVA
-linedebug
-lineuvmdebug
+incdir+./sv
+incdir+./sv/pat
+incdir+./example/mastersv_slavesv
+incdir+./v
+incdir+./adaptor
-sv_lib ./dpi/xbus_parser.so
#-input simvision.tcl
#-gui
-batch

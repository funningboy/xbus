
## purpose
a sample bus UVM/SV verification env that contains direct pattern, random pattern, trx replay pattern

## pattern definition
1. direct pattern : normal read/write test, like read after write test, the expected and answer had already known
2. random pattern : random test based on it's constrain rule set
3. trx replay pattern : replay trx via DPI interface supported

## how to run it?
1.you can check our testsuites first, we provide three kinds of test at path ./sv/pat

1.1. for direct pattern
+UVM_TESTNAME=test_xbus_normal_rw_seq_lib

1.2. for random pattern
+UVM_TESTNAME=test_xbus_random_rw_seq_lib

1.3. for trx replay pattern
+UVM_TESTNAME=test_xbus_adaptor_seq_lib

2.setup irun env
please make sure your irun version is > 12.x

3.% irun -f run.f


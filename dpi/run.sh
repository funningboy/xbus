

# build up xbus_parser.so
bison -d xbus_parser.y
flex xbus_parser.l
g++ xbus_parser.tab.c lex.yy.c xbus_transfer.cpp xbus_wrapper.cpp -I./ -shared -o xbus_parser.so -lfl -fPIC

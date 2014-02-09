

%{
#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <map>
#include <stdio.h>
#include <stdlib.h>
#include <stdlib.h>
#include "xbus_wrapper.h"

using namespace std;
using namespace XBUS;

void* global_ft; /* xbus_factory ppt */
void* global_mb; /* xbus_maxbusox ppt */
void* global_trx; /* xbus_trx */

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
%}

%{
// function call
void yyerror(const char *s);
char* str2char(std::string str);
%}

%union {
std::string *xbus_string;
   unsigned long xbus_long;
int token;
}
%token <token> RETURN
%token <token> BEGIN_CYCLE
%token <token> END_CYCLE
%token <token> BEGIN_TIME
%token <token> END_TIME
%token <token> RW
%token <token> ADDR
%token <token> DATA
%token <token> BYTEN
%token <token> TLPAREN
%token <token> TRPAREN
%token <token> TCOMMA
%token <token> COMMENT
%token <xbus_string> TIDENTIFIER
%token <xbus_string> SIDENTIFIER

%start program
%%
// root
program : top_stmt
        ;

// for sub stmts
top_stmt : instance_stmt RETURN
         | top_stmt header_stmt RETURN
         | top_stmt body_stmt RETURN
         | top_stmt RETURN
         ;

// header
header_stmt : COMMENT
            BEGIN_CYCLE TCOMMA
            END_CYCLE TCOMMA
            BEGIN_TIME TCOMMA
            END_TIME TCOMMA
            RW TCOMMA
            ADDR TCOMMA
            DATA TLPAREN BYTEN TRPAREN TCOMMA
            ;

// instance, build up xbus maxbusox
instance_stmt : COMMENT SIDENTIFIER
              { global_mb = dpi_xbus_new_xbus_maxbusox(str2char((*$<xbus_string>2))); }
;
// body contains, register trx to xbus maxbusox
body_stmt : { global_trx = dpi_xbus_new_xbus_transfer();
              dpi_xbus_register_xbus_transfer(global_mb, global_trx); } sub_body_stmt;

//sub body, update trx
sub_body_stmt : TIDENTIFIER TCOMMA TIDENTIFIER TCOMMA TIDENTIFIER TCOMMA TIDENTIFIER TCOMMA TIDENTIFIER TCOMMA TIDENTIFIER TCOMMA TIDENTIFIER TLPAREN TIDENTIFIER TRPAREN TCOMMA {
dpi_xbus_set_xbus_transfer_begin_cycle(global_trx, str2char((*$<xbus_string>1)));
dpi_xbus_set_xbus_transfer_end_cycle(global_trx, str2char((*$<xbus_string>3)));
dpi_xbus_set_xbus_transfer_begin_time(global_trx, str2char((*$<xbus_string>5)));
dpi_xbus_set_xbus_transfer_end_time(global_trx, str2char((*$<xbus_string>7)));
dpi_xbus_set_xbus_transfer_rw(global_trx, str2char((*$<xbus_string>9)));
dpi_xbus_set_xbus_transfer_addr(global_trx, str2char((*$<xbus_string>11)));
dpi_xbus_set_xbus_transfer_data(global_trx, str2char((*$<xbus_string>13)));
dpi_xbus_set_xbus_transfer_byten(global_trx, str2char((*$<xbus_string>15)));
};
%%

#ifdef __cplusplus
extern "C" {
  /* parser xbus.trx file */
  void* dpi_xbus_parse_file(char* name) {
  FILE *file = fopen(name, "r");

  if (!file) {
    std::cout << "UVM_ERROR: DPI_XBUS. can't open " << file << std::endl;
    exit(-1);
  }

  yyin = file;

  do {
    yyparse();
  } while (!feof(yyin));
    return global_mb;
  }
}
#endif
// selftest
/*
main() {

FILE *file = fopen("00001563.trx", "r");
if (!file) {
std::cout << "I can't open a.snazzle.file!" << std::endl;
   return -1;
}
yyin = file;
do {
yyparse();
} while (!feof(yyin));
void* trx = dpi_xbus_next_xbus_transfer(global_mb);
std::cout << dpi_xbus_get_xbus_transfer_begin_time(trx) << std::endl;
   }
*/

char* str2char(std::string str) {
  char *cstr = new char[str.length() + 1];
  strcpy(cstr, str.c_str());
  return cstr;
}

void yyerror(const char *s) {
  std::cout << "xbus parse error! : " << s << std::endl;
   // might as well halt now:
  exit(-1);
}

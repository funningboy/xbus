

%{
#include <string>
#include <iostream>
#include "xbus_parser.tab.h"

#define YY_DECL extern "C" int yylex()
/* return string */
#define SAVE_TOKEN yylval.xbus_string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)
%}

%%
[ \t] ;
[\n] return TOKEN(RETURN);
begin_cycle return TOKEN(BEGIN_CYCLE);
end_cycle return TOKEN(END_CYCLE);
begin_time return TOKEN(BEGIN_TIME);
end_time return TOKEN(END_TIME);
r"/"w return TOKEN(RW);
addr return TOKEN(ADDR);
data return TOKEN(DATA);
byten return TOKEN(BYTEN);
"," return TOKEN(TCOMMA);
"(" return TOKEN(TLPAREN);
")" return TOKEN(TRPAREN);
"#" return TOKEN(COMMENT);
[a-fA-FrwRW0-9]* SAVE_TOKEN; return TIDENTIFIER;
[a-zA-Z0-9\._]* SAVE_TOKEN; return SIDENTIFIER;
. printf("LEX_ERROR: DPI_XBUS, Unknown token <%s> !\n", yytext); yyterminate();
%%

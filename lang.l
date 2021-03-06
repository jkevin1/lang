%{
#include <stdio.h>
#define YY_DECL extern "C" int yylex()
#include "lang.tab.h"
int line_num = 1;
%}

%%
[ \t]         ;
[0-9]+\.[0-9]+  { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+          { yylval.ival = atoi(yytext); return INT; }
[a-zA-Z0-9]+    { yylval.sval = strdup(yytext); return STRING; }
\n              { ++line_num; }
.               ;
%%

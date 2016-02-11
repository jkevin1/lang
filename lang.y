%{
#include <stdio.h>
#include <stdlib.h>

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE* yyin;
extern "C" int line_num;

void cleanup();
void yyerror(const char* s);
%}

%union {
  int ival;
  float fval;
  char* sval;
}

%token <ival> INT;
%token <fval> FLOAT;
%token <sval> STRING;

%%
lang:
    lang INT      { printf("Found an int literal on line %d: %d\n", line_num, $2); }
    | lang FLOAT  { printf("Found a float literal on line %d: %f\n", line_num, $2); }
    | lang STRING { printf("Found a string literal on line %d: %s\n", line_num, $2); }
    | INT         { printf("Found an int literal on line %d: %d\n", line_num, $1); }
    | FLOAT       { printf("Found a float literal on line %d: %f\n", line_num, $1); }
    | STRING      { printf("Found a string literal on line %d: %s\n", line_num, $1); }
%%

int main(int argc, char* argv[]) {
  if (argc > 1) {
    printf("Opening file: %s\n", argv[1]);
    FILE* file = fopen(argv[1], "r");
    if (file) {
      yyin = file;
      atexit(cleanup);
    }
  }
  // default to stdin
  do {
    yyparse();
  } while (!feof(yyin));
}

void yyerror(const char* s) {
  fprintf(stderr, "Parse error on line %d: %s\n", line_num, s);
  exit(-1);
}

void cleanup() {
  printf("Closing file\n");
  fclose(yyin);
}

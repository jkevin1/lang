%{
#include <stdio.h>
#include <stdlib.h>

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE* yyin;

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
    lang INT      { printf("Found an int literal: %d\n", $2); }
    | lang FLOAT  { printf("Found a float literal: %f\n", $2); }
    | lang STRING { printf("Found a string literal: %s\n", $2); }
    | INT         { printf("Found an int literal: %d\n", $1); }
    | FLOAT       { printf("Found a float literal: %f\n", $1); }
    | STRING      { printf("Found a string literal: %s\n", $1); }
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
  fprintf(stderr, "Parse error: %s\n", s);
  exit(-1);
}

void cleanup() {
  printf("Closing file\n");
  fclose(yyin);
}

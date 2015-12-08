#ifndef Lexer_HPP
#define Lexer_HPP

#include <llvm/ADT/STLExtras.h>
#include <stdio.h>

#define BUFFER_SIZE 1024

// TODO token flyweights
#define TOK_EOF -1
#define TOK_STRING -2
#define TOK_IDENTIFIER -4
#define TOK_NUMBER -5
typedef char Token;

class Lexer {
 public:
  Lexer(const char* filename);
  Lexer(FILE* source);
  virtual ~Lexer();
  Token getNextToken();
 private:
  char nextChar();
  char lastChar;
  FILE* file; bool owned;
};

#endif

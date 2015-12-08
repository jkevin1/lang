#include "lex.hpp"
#include <ctype.h>
#include <string>

Lexer::Lexer(const char* filename) : owned(true), lastChar(' ') {
  file = fopen(filename, "r");
}

Lexer::Lexer(FILE* source) : owned(false), lastChar('0') {
  file = source;
}

Lexer::~Lexer() {
  if (owned) fclose(file);
}

Token Lexer::getNextToken() {
  while (isspace(lastChar)) lastChar = nextChar();

  if (isalpha(lastChar) || lastChar == '_') {
    std::string value;
    do {
      value += lastChar;
      lastChar = nextChar();
    } while (isalnum(lastChar) || lastChar == '_');
    printf("Identifier: %s\n", value.c_str());
    return TOK_IDENTIFIER;
  }

  if (isdigit(lastChar) || lastChar == '.') {
    std::string value;
    do {
      value += lastChar;
      lastChar = nextChar();
    } while (isdigit(lastChar) || lastChar == '.');
    printf("Number: %lf\n", strtod(value.c_str(), nullptr));
    return TOK_NUMBER;
  }

  if (lastChar == '"') {
    std::string value;
    while ((lastChar = nextChar()) != '"' && lastChar != EOF)
      value += lastChar;
    lastChar = nextChar();
    printf("String: '%s'\n", value.c_str());
    return TOK_STRING;
  }

  if (lastChar == EOF) return TOK_EOF;
  
  if (lastChar == '/') {
    lastChar = nextChar();
    if (lastChar == '/') {
      while (lastChar != EOF && lastChar != '\n' && lastChar != '\r') lastChar = nextChar();
      printf("Comment ignored\n");
      if (lastChar != EOF) return getNextToken();
    }
  }

  if (lastChar == EOF) return TOK_EOF;

  char tok = lastChar;
  lastChar = nextChar();
  printf("Unknown Character: %c\n", tok);
  return lastChar;
}

char Lexer::nextChar() {
  return getc(file);
}

int main(int argc, char* argv[]) {
  Lexer lexer(argv[1]);
  while (lexer.getNextToken() != TOK_EOF);
}

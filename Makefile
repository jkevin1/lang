parse: lex.yy.c lang.tab.c lang.tab.h
	g++ lang.tab.c lex.yy.c -lfl -o parse

lang.tab.c lang.tab.h: lang.y
	bison -d lang.y

lex.yy.c: lang.l lang.tab.h
	flex lang.l

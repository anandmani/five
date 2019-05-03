
CC = g++ -O2 -Wno-deprecated 

tag = -i

ifdef linux
tag = -n
endif

test.out: Ddl.o Interpreter.o QueryPlan.o Statistics.o Record.o Comparison.o ComparisonEngine.o Schema.o File.o Pipe.o BigQ.o RelOp.o Function.o DBFile.o HeapFile.o SortedFile.o y.tab.o yyfunc.tab.o lex.yy.o lex.yyfunc.o test.o
	$(CC) -o test.out Ddl.o Interpreter.o QueryPlan.o Statistics.o Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o Pipe.o HeapFile.o SortedFile.o BigQ.o RelOp.o Function.o y.tab.o yyfunc.tab.o lex.yy.o lex.yyfunc.o test.o -ll -lpthread

gtest.out: Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o Statistics.o y.tab.o lex.yy.o gtest.cc
	g++ -std=c++11 -isystem googletest/include -pthread gtest.cc libgtest.a -o gtest.out Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o Statistics.o y.tab.o lex.yy.o -ll
	
test.o: test.cc
	$(CC) -g -c test.cc
	
Interpreter.o: Interpreter.cc
	$(CC) -g -c Interpreter.cc

Ddl.o: Ddl.cc
	$(CC) -g -c Ddl.cc

Statistics.o: Statistics.cc
	$(CC) -g -c Statistics.cc

Function.o: Function.cc
	$(CC) -g -c Function.cc

QueryPlan.o: QueryPlan.cc
	$(CC) -g -c QueryPlan.cc
	
Comparison.o: Comparison.cc
	$(CC) -g -c Comparison.cc
	
ComparisonEngine.o: ComparisonEngine.cc
	$(CC) -g -c ComparisonEngine.cc
	
DBFile.o: DBFile.cc
	$(CC) -g -c DBFile.cc

Pipe.o: Pipe.cc
	$(CC) -g -c Pipe.cc

BigQ.o: BigQ.cc
	$(CC) -g -c BigQ.cc

RelOp.o: RelOp.cc
	$(CC) -g -c RelOp.cc

File.o: File.cc
	$(CC) -g -c File.cc

Record.o: Record.cc
	$(CC) -g -c Record.cc

Schema.o: Schema.cc
	$(CC) -g -c Schema.cc

HeapFile.o: HeapFile.cc	
	$(CC) -g -c HeapFile.cc	

SortedFile.o: SortedFile.cc	
	$(CC) -g -c SortedFile.cc

y.tab.o: Parser.y
	yacc -d Parser.y
	gsed $(tag) y.tab.c -e "s/  __attribute__ ((__unused__))$$/# ifndef __cplusplus\n  __attribute__ ((__unused__));\n# endif/" 
	g++ -c y.tab.c

yyfunc.tab.o: ParserFunc.y
	yacc -p "yyfunc" -b "yyfunc" -d ParserFunc.y
	#gsed $(tag) yyfunc.tab.c -e "s/  __attribute__ ((__unused__))$$/# ifndef __cplusplus\n  __attribute__ ((__unused__));\n# endif/" 
	g++ -c yyfunc.tab.c

lex.yy.o: Lexer.l
	lex  Lexer.l
	gcc  -c lex.yy.c

lex.yyfunc.o: LexerFunc.l
	lex -Pyyfunc LexerFunc.l
	gcc  -c lex.yyfunc.c

clean: 
	rm -f *.o
	rm -f *.out
	rm -f y.tab.c
	rm -f lex.yy.c
	rm -f y.tab.h

yacc second.y
flex first.l
gcc lex.yy.c -lfl -lm
./a.out


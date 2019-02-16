%{
#include<ctype.h>
#include <stdio.h>
#include<math.h>

int yylex(void);
void yyerror(char *);

struct number
{
 
  int ival;
  double fval;
  int type;
  
};
int INT_TYPE = 1;
int DOUBLE_TYPE = 2;
%}
%union {
	struct number values;
}
%token INTEGER DOUBLE IDENTIFIER 
%token <values> INTEGER_VALUE 
%token <values> DOUBLE_VALUE
%type <values> program 
%type <values> expr 
%type <values> value
%% 
program:
          program expr '\n'         { $$=$2;
					if($$.type==1)
					printf("=> %d\n",$$.ival);
				      else
					printf("=> %f\n",$$.fval);
				    }
	|         
        ;

expr:	
	  IDENTIFIER ':' DOUBLE '=' DOUBLE_VALUE ';'    { $$.fval = $5.fval ; $$.type=2; }
	| IDENTIFIER ':' INTEGER '=' INTEGER_VALUE ';'  { $$.ival = $5.ival ; $$.type=1; }
        | value			 
        | expr '+' expr           { 
					if($1.type==1 && $3.type==1){ 
						$$.ival = $1.ival + $3.ival;
						$$.fval=$$.ival*1.0;
						$$.type=1;
						
					}else{
						$$.fval = $1.fval + $3.fval;
						$$.type=2;
					}
				}
        ;
value:
 	INTEGER_VALUE
	| DOUBLE_VALUE
	;
	
%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}


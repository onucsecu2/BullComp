%{
#include<ctype.h>
#include <stdio.h>
#include<math.h>



int yylex(void);
void yyerror(char *);
void varTable(int vali,double valf,int type,char * );

struct number
{
 
  int ival;
  double fval;
  int type;
  char *var;
};
struct number varGet(char * );
struct number map[50];
int INT_TYPE = 1;
int DOUBLE_TYPE = 2;
int vindex=0;
int errline=0;
int errcol=0;
%}
%union {
	struct number values;
	
}
%token INTEGER DOUBLE ECHO DEF RETURN IF ELSE FOR EXTERN PRINTI EQ NE GE LE IN TO BY
%token <values> INTEGER_VALUE 
%token <values> DOUBLE_VALUE
%token <values> IDENTIFIER
%type <values> program 
%type <values> expr 
%type <values> value
%type <values> stmt
%type <values> block
%% 
program             : program stmt          
	                | 	
                    ;
stmt	            :  expr new_line
	                | IF '(' expr ')' new_line block ELSE new_line block 
	                | IF '(' expr ')' new_line block
	                | FOR '(' IDENTIFIER ':' INTEGER IN expr TO expr ')' block
	                | FOR '(' IDENTIFIER ':' INTEGER IN expr TO expr BY expr ')' block
	                | extern_decl '\n'
	                ;
var_decl            : IDENTIFIER ':' DOUBLE '=' DOUBLE_VALUE 
	                | IDENTIFIER ':' INTEGER '=' INTEGER_VALUE 	
    	            | IDENTIFIER ':' INTEGER '=' expr 		
	                | IDENTIFIER ':' INTEGER 			
	                | IDENTIFIER ':' DOUBLE				
	                | IDENTIFIER '=' expr
	                ;
expr                : IDENTIFIER		  
	                | value			 
                    | expr '+' expr           
	                | expr '-' expr		
	                | expr '*' expr		
	                | expr '/' expr		
	                | expr comparison expr  
	                | '(' expr ')'
	                | RETURN expr new_line
                    | call_func
	                | func_decl
	                | var_decl new_line
                    | expr new_line
                    | ECHO '(' expr ')' '\n'
                    | PRINTI'(' expr ')' '\n'       		
	                ;
comparison          : EQ | NE | '<' | LE | '>' | GE ;
call_func           : IDENTIFIER  '(' call_args ')' new_line
                    | '(' call_args ')' new_line
	                ;
value               : INTEGER_VALUE
	                | DOUBLE_VALUE
	                ;
func_decl           : DEF IDENTIFIER '(' func_decl_args ')' ':'  INTEGER '=''>' block
                    | DEF IDENTIFIER '(' func_decl_args ')' ':'  DOUBLE '=''>' block 
	                | '('func_decl_args')' ':'  INTEGER '=''>' block
                    | '('func_decl_args')' ':'  DOUBLE '=''>' block 
	                ;
func_decl_args      : var_decl    
	                | func_decl_args ',' var_decl
	                |
	                ;
call_args           : expr   
	                | call_args ',' expr
	                |
	                ;
block               : '{' new_line expr new_line '}' new_line	
	                | '{' new_line '}' new_line
	                ;
new_line            : '\n'
	                |
	                ;
extern_decl         : EXTERN  IDENTIFIER '(' func_decl_args ')' ':'  IDENTIFIER
	                ;
%%
void yyerror(char *s) {
    fprintf(stderr, "%s in line no:%d at \n", s,errline+1);
    exit(0);
}
void varTable(int vali,double valf,int type,char *s ){
	map[vindex].ival=vali;
	map[vindex].fval=valf;
	map[vindex].type=type;
	map[vindex].var=s;
	vindex++;
	
}
struct number varGet(char *s ){
	for(int i=0;i<vindex;i++){
		if(!strcmp(map[i].var,s)){
			return map[i];
		}	
	}
	yyerror("undeclared variable detected !");
}
int main(void) {
    yyparse();
    return 0;
}


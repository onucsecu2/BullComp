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
int lineno=0;
%}
%union {
	struct number values;
	
}
%token INTEGER DOUBLE ECHO DEF RETURN
%token <values> INTEGER_VALUE 
%token <values> DOUBLE_VALUE
%token <values> IDENTIFIER
%type <values> program 
%type <values> expr 
%type <values> value
%type <values> stmt
%type <values> block
%% 
program:
          program stmt '\n'         { $$=$2;lineno++;}
	|          
        ;
stmt	: ECHO '(' expr ')' 	 		{ $$ = $3; 
						if($$.type==1)
							printf("=> %d\n",$$.ival);
				      		else
							printf("=> %f\n",$$.fval);}
	| var_decl
	| func_decl			
	;
var_decl :  IDENTIFIER ':' DOUBLE '=' DOUBLE_VALUE        { varTable($5.ival,$5.fval    ,2,$1.var) ;}
	| IDENTIFIER ':' INTEGER '=' INTEGER_VALUE 	{ varTable($5.ival,1.0*$5.ival,1,$1.var) ;}
    	| IDENTIFIER ':' INTEGER '=' expr		{ varTable($5.ival,1.0*$5.ival,1,$1.var) ;}
	| IDENTIFIER ':' INTEGER			{ varTable(0,0    ,1,$1.var) ;}
	| IDENTIFIER ':' DOUBLE				{ varTable(0,0    ,2,$1.var) ;}
	| IDENTIFIER '=' expr	
	;
expr:	  
	  IDENTIFIER		  { $$ = varGet($1.var);  }
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
	| expr '-' expr		{ 
					if($1.type==1 && $3.type==1){ 
						$$.ival = $1.ival - $3.ival;
						$$.fval=$$.ival*1.0;
						$$.type=1;
						
					}else{
						$$.fval = $1.fval - $3.fval;
						$$.type=2;
					}
				}
	| expr '*' expr		{ 
					if($1.type==1 && $3.type==1){ 
						$$.ival = $1.ival * $3.ival;
						$$.fval=$$.ival*1.0;
						$$.type=1;
						
					}else{
						$$.fval = $1.fval * $3.fval;
						$$.type=2;
					}
				}
	| expr '/' expr		{ 
					if($1.type==1 && $3.type==1){ 
						$$.ival = $1.ival / $3.ival;
						$$.fval=$$.ival*1.0;
						$$.type=1;
						
					}else{
						$$.fval = $1.fval / $3.fval;
						$$.type=2;
					}
				}
	| '(' expr ')'
	| RETURN expr        		{$$=$2; }
	;
value:
 	INTEGER_VALUE
	| DOUBLE_VALUE
	;
func_decl : 
	DEF IDENTIFIER '(' func_decl_args ')' ':'  INTEGER '=''>' block 
	| '('func_decl_args')' ':'  IDENTIFIER '=''>' block 
	;
func_decl_args :
	var_decl    
	| func_decl_args ',' var_decl
	|
	; 
block   : '{' expr '}' 			{$$=$2; }
	| '{' '}'  
	;

%%
void yyerror(char *s) {
    fprintf(stderr, "%s in line no:%d at \n", s,lineno+1);
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


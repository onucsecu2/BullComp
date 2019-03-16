/* scanner for a toy Pascal-like language */
%{
#include <math.h>
#include "y.tab.c"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror(char *);
char *p;
%}
DIGIT [0-9]
ID [A-Za-z_][_A-Za-z0-9]*
%%
{DIGIT}+ {
	yylval.values.ival = atoi(yytext);
	yylval.values.fval = atof(yytext);
	yylval.values.type = 1;
	return INTEGER_VALUE;
}
{DIGIT}+"."{DIGIT}* {
	yylval.values.fval = atof(yytext);
	yylval.values.type = 2;
	return DOUBLE_VALUE;
}
return {return RETURN; }
echo {return ECHO; }
def {return DEF; }
double { return DOUBLE; }
int {return INTEGER;}
{ID}  {                p=(char *)calloc(strlen(yytext)+1,sizeof(char));
                       strcpy(p,yytext);
                       yylval.values.var=p; ;return IDENTIFIER; }
[-+*/:=;><,.(){}\n]      { return *yytext; }

[ \t]       ;

.          { printf("%s\n",yytext); yyerror("Unknown character encountered ");
}
%%

int yywrap(void) {
    return 1;
} 


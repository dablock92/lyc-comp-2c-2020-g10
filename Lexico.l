/**
  
 	GRUPO 10
 	Bermudez, Pablo					35337444			
	Ambroso, Nahuel 				34575684
	Luna Sanchez, Matias Leonel 	37141163
	Andres, Martin 					39626806
	Masini, Ezequiel 				39562503
       
*/

%{

#include "y.tab.h"
#include "lexico.h"

%}

%option noyywrap
%option yylineno

DIGITO									[0-9]
LETRA									[a-zA-Z]
ID										{LETRA}({LETRA}|{DIGITO}|_)*
CTE_REAL								(-?{DIGITO}*"."({DIGITO}+|{DIGITO}*))
CTE_INT									-?{DIGITO}+
CARACTER								[a-z|A-Z|0-9|=|>|<|!|:|+|-|*|!|¡|%|#|/|\|-|_|.|,|;||]
SEPARADOR								[ \t\n\r]
COMENTARIO								\*-.({CARACTER}|{SEPARADOR})*.
COMENTARIO_ANIDADO                      {COMENTARIO}({COMENTARIO}-\*)?.-\*
CTE_STRING								\"({CARACTER}+|{SEPARADOR})*\"


%%

"DIM"									{ return DIM; }

"AS"									{ return AS; }

"CONST"									{ return CONST; }

"PUT"									{ return PUT; }

"GET"									{ return GET; }

"while"									{ return WHILE; }

"if"									{ return IF; }

"Else"									{ return ELSE; }

"and"									{ return AND; }

"or"									{ return OR; }

"not"									{ return NOT; }

"contar"								{ return CONTAR; }

"Float"									{ 
											strcpy(yylval.valor_string, yytext); 
											return FLOAT;
										}

"Integer"								{ 
											strcpy(yylval.valor_string, yytext); 
											return INTEGER; 
										}

"String"								{ 
											strcpy(yylval.valor_string, yytext); 
											return STRING; 
										}

{CTE_INT}								{ 
											is_valid_int(); 
											yylval.valor_int = atoi(yytext);  
											return CTE_INT; 
										}

{CTE_STRING}							{ 
											is_valid_string(); 
											strcpy(yylval.valor_string, yytext);  
											return CTE_STRING; 
										}

{CTE_REAL}								{ 
											is_valid_float(); 
											yylval.valor_float = atof(yytext);  
											return CTE_REAL; 
										}

{ID}									{ 
											strcpy(yylval.valor_string, yytext); 
											return ID; 
										}

{COMENTARIO}

{SEPARADOR}

{COMENTARIO_ANIDADO}

"("										{ return PA; }

")"										{ return PC; }

"{"										{ return LA; }

"}"										{ return LC; }

"["										{ return CA; }

"]"										{ return CC; }

";"										{ return PUNTO_Y_COMA; }

","										{ return COMA; }

"_"										{ return GUION_BAJO; }

":"										{ return OP_ASIG; }

"="										{ return OP_ASIG_CONST; }

"+"										{ return OP_SUMA; }

"-"										{ return OP_RESTA; }

"*"										{ return OP_MULT; }

"/"										{ return OP_DIV; }

">"										{ return MAYOR; }

">="									{ return MAYOR_IGUAL; }

"<"										{ return MENOR; }

"<="									{ return MENOR_IGUAL; }

"=="									{ return IGUAL; }

"<>"									{ return DISTINTO; }


%%

void is_valid_int() 
{
	if (atoll(yytext) < INT_MIN || atoll(yytext) > INT_MAX) 
	{
		printf("Capacidad maxima de constante entera excedida en la linea %d\n", yylineno);
		exit(1);
	}
}

void is_valid_float() 
{
	if (atof(yytext) < FLOAT_MIN || atof(yytext) > FLOAT_MAX) 
	{
		printf("Capacidad maxima de constante float excedida en la linea %d\n", yylineno);
		exit(1);
	}
}

void is_valid_string() 
{
	if (yyleng > STRING_MAX_CHAR) 
	{
		printf("Capacidad maxima de caracteres asignados superada en la linea %d\n", yylineno);
		exit(1);
	}
}
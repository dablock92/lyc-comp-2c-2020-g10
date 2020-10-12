%{
 
#include "symbol_table.h"
#define YYDEBUG 1

extern int yyparse();
void yyerror(const char *s);
extern FILE* yyin;
extern int yylineno;
extern int yyleng;
extern char *yytext;

int count_variable;
int count_tipo_variable;
void verificar_cant_variables();

%}

%start programa

%token ID CTE_INT CTE_STRING CTE_REAL

%token DIM AS

%token CONST

%token INTEGER FLOAT STRING

%token IF ELSE

%token WHILE

%token OP_ASIG OP_ASIG_CONST OP_SUMA OP_RESTA OP_MULT OP_DIV

%token MENOR MAYOR IGUAL DISTINTO MENOR_IGUAL MAYOR_IGUAL

%token AND OR NOT

%token PA PC CA CC LA LC

%token GUION_BAJO COMA PUNTO_Y_COMA DOS_PUNTOS

%token PUT GET

%token CONTAR


%union
{
    int valor_int;
    float valor_float;
    char valor_string[32];
}
%%

programa: 
	bloque_declaracion_variable bloque 							{printf("\n Se lee regla: <programa> \n");};
  
bloque_declaracion_variable: 
	bloque_declaracion_variable sentencia_variables 			{printf("\n Se lee regla: <bloque_declaracion_variable> <sentencia_variables> \n");}
	| sentencia_variables 										{printf("\n Se lee regla: <sentencia_variables> \n");};
	
sentencia_variables: 
	DIM MENOR lista_IDs MAYOR AS MENOR tipos_de_datos MAYOR 	{
																	printf("\n Se lee regla: DIM MENOR <declaracion_variables> MAYOR AS MENOR <tipos_de_datos> MAYOR \n"); 
																	verificar_cant_variables();
																};
  
lista_IDs: 
	lista_IDs COMA ID   										{
																	printf("\n Se lee regla: <lista_IDs> COMA ID \n"); 
																	count_variable++; 
																	buscar_tabla_simbolos(yytext , &tabla_simbolos);
																}
	|ID 														{
																	printf("\n Se lee regla: ID \n");
																	count_variable++; 
																	buscar_tabla_simbolos(yytext , &tabla_simbolos);
																};
  
tipos_de_datos: 
	tipos_de_datos COMA tipo_dato 								{
																	printf("\n Se lee regla: <lista_IDs> COMA <tipo_dato> \n"); 
																	count_tipo_variable++;
																}
	|tipo_dato 													{
																	printf("\n Se lee regla: <tipo_dato> \n"); 
																	count_tipo_variable++;
																};

tipo_dato: 
	INTEGER 													{printf("\n Se lee regla: INTEGER \n");}
	| FLOAT 													{printf("\n Se lee regla: FLOAT \n");}
	| STRING 													{printf("\n Se lee regla: STRING \n");};
  
bloque: 
	sentencia PUNTO_Y_COMA 										{printf("\n Se lee regla: <sentencia> PUNTO_Y_COMA \n");}
	| bloque sentencia PUNTO_Y_COMA 							{printf("\n Se lee regla: <bloque> <sentencia> PUNTO_Y_COMA \n");}
	| bloque sentencia 											{printf("\n Se lee regla: <bloque> <sentencia> \n");}
	| sentencia 												{printf("\n Se lee regla: <sentencia> \n");};
  
sentencia: 
	bloque_if 													{printf("\n Se lee regla: <bloque_if> \n");}
	| asignacion 												{printf("\n Se lee regla: <asignacion> \n");}
	| put 														{printf("\n Se lee regla: <put> \n");}
	| get 														{printf("\n Se lee regla: <get> \n");}
	| bloque_while 												{printf("\n Se lee regla: <bloque_while> \n");}
	| asignacion_constante  									{printf("\n Se lee regla: <asignacion_constante> \n");};
  
bloque_if: 
	IF PA condicion PC LA bloque LC ELSE LA bloque LC 			{printf("\n Se lee regla: IF PA <condicion> PC LA <bloque> LC ELSE LA <bloque> LC \n");}
	| IF PA condicion PC LA bloque LC 							{printf("\n Se lee regla: IF PA <condicion> PC LA <bloque> LC \n");};
	| IF PA condicion PC sentencia								{printf("\n Se lee regla: IF PA <condicion> PC <sentencia>  \n");};
	| IF PA condicion PC sentencia ELSE sentencia 				{printf("\n Se lee regla: IF PA <condicion> PC <sentencia> ELSE <sentencia> \n");};

bloque_while: 
	WHILE PA condicion PC LA bloque LC 							{printf("\n Se lee regla: WHILE PA <condicion> PC LA <bloque> LC \n");};
	
asignacion: 
	ID OP_ASIG expresion 										{printf("\n Se lee regla: ID OP_ASIG <expresion> \n");};
  
asignacion_constante: 
	CONST ID OP_ASIG_CONST expresion 							{printf("\n Se lee regla: CONST ID OP_ASIG_CONST <expresion> \n");};
  
lista_expresiones: 
	lista_expresiones COMA termino 								{printf("\n Se lee regla: <lista_expresiones> COMA <termino> \n");}
	| termino 													{printf("\n Se lee regla: <termino> \n");};
 
put: 
	PUT ID 														{printf("\n Se lee regla: PUT ID \n");}
	| PUT CTE_INT 												{printf("\n Se lee regla: PUT CTE_INT \n");}
	| PUT CTE_REAL 												{printf("\n Se lee regla: PUT CTE_REAL \n");}
	| PUT CTE_STRING 											{printf("\n Se lee regla: PUT CTE_STRING \n");};
 
get: 
	GET ID 														{printf("\n Se lee regla: GET ID \n");};
  
condicion: 
	comparacion 												{printf("\n Se lee regla: <comparacion> \n");}
	| comparacion operador_logico comparacion 					{printf("\n Se lee regla: <comparacion> <operador_logico> <comparacion> \n");}
	| NOT PA comparacion PC 									{printf("\n Se lee regla: NOT <comparacion> \n");};
  
comparacion: 
	expresion comparador expresion 								{printf("\n Se lee regla: <expresion> <comparador> <expresion> \n");};
  
comparador: 
	IGUAL 														{printf("\n Se lee regla: IGUAL \n");}
	| DISTINTO 													{printf("\n Se lee regla: DISTINTO \n");}
	| MAYOR 													{printf("\n Se lee regla: MAYOR \n");}
	| MAYOR_IGUAL 												{printf("\n Se lee regla: MAYOR_IGUAL \n");}
	| MENOR 													{printf("\n Se lee regla: MENOR \n");}
	| MENOR_IGUAL 												{printf("\n Se lee regla: MENOR_IGUAL \n");};
  
operador_logico: 
	OR 															{printf("\n Se lee regla: OR \n");}
	| AND 														{printf("\n Se lee regla: AND \n");};
  
expresion: 
	expresion OP_SUMA termino 									{printf("\n Se lee regla: <expresion> OP_SUMA <termino> \n");}
	| expresion OP_RESTA termino 								{printf("\n Se lee regla: <expresion> OP_RESTA <termino> \n");}
	| termino 													{printf("\n Se lee regla: <termino> \n");};
  
termino: 
	termino OP_MULT factor 										{printf("\n Se lee regla: <termino> OP_MULT <factor> \n");}
	| termino OP_DIV factor 									{printf("\n Se lee regla: <termino> OP_DIV <factor> \n");}
	| factor 													{printf("\n Se lee regla: <factor> \n");};
  
factor: 
	ID 															{
																	printf("\n Se lee regla: ID \n"); 
																	buscar_tabla_simbolos(yytext , &tabla_simbolos);
																}
	| CTE_INT 													{
																	printf("\n Se lee regla: CTE_INT \n"); 
																	buscar_tabla_simbolos(yytext , &tabla_simbolos);
																}
	| CTE_REAL 													{ 
																	printf("\n Se lee regla: CTE_REAL \n"); 
																	buscar_tabla_simbolos(yytext , &tabla_simbolos);
																}
	| CTE_STRING 												{
																	printf("\n Se lee regla: CTE_STRING \n"); 
																	buscar_tabla_simbolos(yytext , &tabla_simbolos);
																}
	| PA expresion PC 											{
																	printf("\n Se lee regla: PA <expresion> PC \n");
																}
	| contar 													{ 
																	printf("\n Se lee regla: <contar> \n");
																};
																
contar: 
	CONTAR PA expresion PUNTO_Y_COMA CA lista_expresiones CC PC {printf("\n Se lee regla: CONTAR PA <expresion> PUNTO_Y_COMA CA <lista_expresiones> CC PC \n");};
  
%%

int main(int argc, char *argv[])
{
	tabla_simbolos = NULL;

    yydebug = 0;
    if ((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
		exit(1);
    }
  
    yyparse();
    fclose(yyin);
	escribir_tabla_simbolos();
    printf("\n FIN DE COMPILACION \n");

    return 0;
}

void yyerror(const char *str)
{
    fprintf(stderr,"ERROR: %s en la linea %d\n", str, yylineno);
    system ("Pause");
    exit (1);
}

void verificar_cant_variables() 
{
    if(count_variable != count_tipo_variable) {
      printf("\nLa cantidad de variables no coincide con la cantidad de tipos\n");
      exit(1);
    } 	
}

int buscar_tabla_simbolos(char *yytext, tLista * tabla_simbolos)
{
    while( *tabla_simbolos )
    {
        if( (strcmp(yytext, ((*tabla_simbolos)->info).valor) == 0))
            return 0;
        
        tabla_simbolos = &(*tabla_simbolos)->sig;
    }

    insertar_tabla_simbolos(yytext);
    return 1;
}

void escribir_tabla_simbolos(){
	
    FILE* archivo_tabla = fopen("ts.txt","wt");

    if(!archivo_tabla)
	{
		printf("No se pudo abrir el archivo");
		exit(1);
	}
        
	fprintf(archivo_tabla,"TABLA DE SIMBOLOS\n");
    fprintf(archivo_tabla,"\n%20s\t%20s\t%20s\t%20s\n", "NOMBRE", "TIPO DE DATO", "VALOR", "LONGITUD");
	
    while(tabla_simbolos)
    {
		fprintf(archivo_tabla,"%-30s|%-15s|%-30s|%-15s\n",(tabla_simbolos)->info.lexema,"",(tabla_simbolos)->info.valor, "");
		tabla_simbolos = (*tabla_simbolos).sig;
    }
	fclose(archivo_tabla);
}

int insertar_tabla_simbolos(char *yytext)
{
    tDato dato;
	char* valor,*lexema;
	tNodo * newNodo;

	dato.valor = (char*) malloc(sizeof(char[yyleng + 1]));
    dato.lexema = (char*) malloc(sizeof(char[yyleng+2]));
	newNodo = (tNodo*) malloc (sizeof(tNodo));

    if(!dato.valor || !dato.lexema || !newNodo)
		return 0;
	
    strcpy(dato.valor,yytext);
    strcpy(dato.lexema,"_");
    strcat(dato.lexema,yytext);

    newNodo->info = dato;
    newNodo->sig  = tabla_simbolos;
    tabla_simbolos = newNodo;
    return 1;
}



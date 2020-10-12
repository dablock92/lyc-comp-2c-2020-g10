#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
  char *lexema;
  char *valor;

}tInfo;

typedef tInfo tDato;

typedef struct sNodo
{
  tDato info;
  struct sNodo *sig;

}tNodo;

typedef tNodo *tLista; 

int buscar_tabla_simbolos(char * , tLista * );
int insertar_tabla_simbolos (char *);
void escribir_tabla_simbolos();

tLista tabla_simbolos;



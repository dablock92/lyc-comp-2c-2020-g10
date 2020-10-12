#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <float.h>
#include <string.h>

#define INT_MAX 32767
#define INT_MIN -32768
#define FLOAT_MAX 3.402823e+38
#define FLOAT_MIN 1.175494e-38
#define STRING_MAX_CHAR 32 /*Se agregan 2 a los 30 caracteres debido a que se suman las dos dobles comillas que acompaniar el string*/

void is_valid_string();
void is_valid_float();
void is_valid_int();


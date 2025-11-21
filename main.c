#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "src/constantes.h"

extern char *codificar(char *bytes, size_t agregar_iguales);

void escribir_caracteres(FILE *archivo, char *caracteres)
{
	if (archivo == NULL)
		return;

	int i = 0;
	for (i = 0; i < 4; i++)
		fprintf(archivo, "%c", caracteres[i]);
	if (caracteres[i] == '=') {
		fprintf(archivo, "%c", caracteres[i]);
		i++;
	}
	if (caracteres[i] == '=')
		fprintf(archivo, "%c", caracteres[i]);
}

int main()
{
	FILE *archivo_binario = fopen(ARCH_BIN, MODO_LECTURA);
	FILE *archivo_texto = fopen(ARCH_TXT, MODO_ESCRITURA);
	if (archivo_binario == NULL || archivo_texto == NULL) {
		printf(ERROR_APERTURA "\n");
		return ERROR;
	}
	printf(EXITO_APERTURA "\n");

	unsigned char bytes[3];
	size_t cant_leidos;
	while ((cant_leidos = fread(bytes, sizeof(char), 3, archivo_binario)) > 0) {
		size_t agregar_iguales = 0;
		if (cant_leidos == 1) {
			agregar_iguales = 2;
			bytes[1] = 0;
			bytes[2] = 0;
		} else if (cant_leidos == 2) {
			agregar_iguales = 1;
			bytes[2] = 0;
		}
		char *caracteres = codificar(bytes, agregar_iguales);

		escribir_caracteres(archivo_texto, caracteres);
	}

	fclose(archivo_binario);
    fclose(archivo_texto);

	return 0;
}

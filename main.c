#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "src/constantes.h"

extern char *codificar(char *bytes, size_t agregar_iguales);

void escribir_caracteres(FILE *archivo, char *caracteres, size_t cantidad_caracteres)
{
	if (archivo == NULL)
		return;

	for (int i = 0; i < cantidad_caracteres; i++)
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
	size_t cant_leidos = fread(bytes, sizeof(char), 3, archivo_binario);
	while (!feof(archivo_binario)) {
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

		size_t cantidad = strlen(caracteres);
		escribir_caracteres(archivo_texto, caracteres, cantidad);

		cant_leidos = fread(bytes, sizeof(char), 3, archivo_binario);
	}

	fclose(archivo_binario);
    fclose(archivo_texto);

	return 0;
}

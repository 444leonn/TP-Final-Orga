#include <stdio.h>
#include <stdbool.h>

#define ARCH_BIN "./inputBinario.bin"
#define ARCH_TXT "outputTexto.txt"
#define MODO_LECTURA "r"
#define MODO_ESCRITURA "w"
#define ERROR_APERTURA "Error, al abrir archivo."
#define EXITO_APERTURA "Archivos Abiertos correctamente."
#define ERROR -1

void escribir_caracteres(FILE *archivo, char *caracteres)
{
	if (archivo == NULL)
		return;

	fprintf(archivo, "%s", caracteres);
}

char *codificar(char *bytes, size_t cantidad_bytes, size_t agregar_iguales);

int main()
{
	FILE *archivo_binario = fopen(ARCH_BIN, MODO_LECTURA);
	FILE *archivo_texto = fopen(ARCH_TXT, MODO_ESCRITURA);
	if (archivo_binario == NULL || archivo_texto == NULL) {
		printf(ERROR_APERTURA "\n");
		return ERROR;
	}
	printf(EXITO_APERTURA "\n");

	char bytes[3];
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
		char *caracteres = codificar(bytes, 3, agregar_iguales);

		escribir_caracteres(archivo_texto, caracteres);

		cant_leidos = fread(bytes, sizeof(char), 3, archivo_binario);

	}

	fclose(archivo_binario);
    fclose(archivo_texto);

	return 0;
}

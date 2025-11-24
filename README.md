# TP Final Organización del Computador

## Integrantes

- León Acosta
- Santiago del Monaco

## Instrucciones

Para compilar y ejecutar el programa se provee un archivo de `makefile` que permite facilitarlo.

- Compilar:

  ```bash
  # compilar el programa
  make
  ```

- Ejecutar:

  ```bash
  # correr el programa
  make ejecutar
  ```

> [!IMPORTANT]
> El archivo esperado para codificar debe ser nombrado `inputBinario.bin` y debe estar en el mismo directorio que el programa principal `main.c`.
> Dentro del directorio `/casos` se encuentran algunos archivos que se pueden utilizar a modo de testeo.

## Desarrollo del Trabajo

El programa funciona abriendo un archivo binario, leyendo sus bytes de manera iterativa y codificandolos a caracteres imprimibles en Base64.

Luego son escritos en el segundo archivo de destino de texto.

### Codificación

El programa principal fue escrito en lenguaje C, y es en el mismo que se realiza el manejo de archivos, apertura, lectura, escritura y cierre.

Luego la codificación de los bytes leídos hacia caracteres imprimibles de la tabla en Base64 fue realizada en Netwide Assembler (NASM).

En donde se reciben los tres bytes ya leídos y la cantidad de iguales que se deben agregar si es necesario.

Se utiliza la convención de llamada a funciones desde C para Linux, por lo que se toman como registros para los parámetros de la función los registros `rdi` y `rsi`. Y para el valor a retornar el registro `rax`

``` c
  rax                 rdi         rsi
   ↓                   ↓           ↓
char *codificar(char *bytes, size_t agregar_iguales)
```

Además estos registros también son utilizados ciertos registros de manera auxiliar que permiten realizar distintas operaciones, como el acceso a indices, o valores empleados en contadores de bucle.

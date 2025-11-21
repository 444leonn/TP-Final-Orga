ASMFLAGS=-f elf64 -g -F dwarf -l
CFLAGS=-no-pie -g -z noexecstack

main:
	nasm $(ASMFLAGS) src/codificar.lst -o src/codificar.o src/codificar.asm
	gcc $(CFLAGS) src/codificar.o main.c -o main

ejecutar: main
	./main
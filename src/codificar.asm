;;;  Codificacion de Bytes a Caracteres en BASE64
section .data
    tabla_imprimibles   db  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", 0

section .bss
    resultado   resb    6

section .text
    global codificar

codificar:
    push rbx
    push r12
    push r13
    push r14
    
    mov r12, rsi
    
    ; combinar los 3 bytes
    xor rax, rax
    mov al, byte [rdi]
    shl rax, 8
    mov al, byte [rdi + 1]
    shl rax, 8
    mov al, byte [rdi + 2]
    mov r13, rax
    
    ; puntero a resultado
    lea rbx, [rel resultado]
    
    ; contador de loop
    xor r14, r14
loop_codificar:
    cmp r14, 4
    jge agregar_iguales
    
    ; calcular cuantos bits desplazar: 18, 12, 6, 0
    mov rax, 3
    sub rax, r14            ; rax = 3 - i
    imul rax, 6             ; rax = (3 - i) * 6
    
    ; extraer 6 bits
    mov rdx, r13
    mov rcx, rax            ; rcx = cantidad de bits a desplazar
    shr rdx, cl
    and rdx, 0x3F           ; mascara para obtener solo 6 bits
    
    ; obtener carácter de la tabla
    lea rsi, [rel tabla_imprimibles]
    add rsi, rdx
    mov dl, byte [rsi]
    
    ; guardar
    mov byte [rbx + r14], dl
    
    inc r14
    jmp loop_codificar
    
agregar_iguales:
    cmp r12, 0
    je fin
    
    ; indice despues de los 4 caracteres
    mov rax, 4
loop_iguales:
    mov byte [rbx + rax], '='
    inc rax
    dec r12
    jnz loop_iguales
    
fin: 
    ; retorna puntero a resultado
    mov rax, rbx
    
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
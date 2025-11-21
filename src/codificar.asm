;;;  Codificacion de Bytes a Caracteres en BASE64

section .data
    tabla_imprimibles   db  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", 0

section .bss
    resultado   resb    5   ; 4 caracteres + null terminator

section .text
    global codificar

; char *codificar(char *bytes, size_t agregar_iguales)
; rdi = puntero a los 3 bytes
; rsi = cantidad de '=' a agregar (0, 1 o 2)
codificar:
    push rbx
    push r12
    push r13
    push r14
    
    ; Guardar cantidad de '=' en r12
    mov r12, rsi
    
    ; Combinar los 3 bytes en un valor de 24 bits en r13
    ; r13 = (byte0 << 16) | (byte1 << 8) | byte2
    xor rax, rax                ; Pone en 0 el rax
    mov al, byte [rdi]          ; Primer byte
    shl rax, 8
    mov al, byte [rdi + 1]      ; Segundo byte
    shl rax, 8
    mov al, byte [rdi + 2]      ; Tercer byte
    mov r13, rax                ; r13 contiene los 24 bits
    
    ; Inicializar contador de loop
    xor r14, r14            ; r14 = índice del carácter (0-3)
    
    ; Puntero a resultado
    lea rbx, [rel resultado]
    
.loop_codificar:
    cmp r14, 4
    jge .agregar_iguales
    
    ; Calcular cuántos bits desplazar: 18, 12, 6, 0
    mov rax, 3
    sub rax, r14            ; rax = 3 - i
    imul rax, 6             ; rax = (3 - i) * 6
    
    ; Extraer 6 bits
    mov rdx, r13
    mov rcx, rax            ; rcx = cantidad de bits a desplazar
    shr rdx, cl             ; desplazar a la derecha
    and rdx, 0x3F           ; máscara para obtener solo 6 bits
    
    ; Obtener carácter de la tabla
    lea rsi, [rel tabla_imprimibles]
    add rsi, rdx
    mov dl, byte [rsi]
    
    ; Guardar en resultado
    mov byte [rbx + r14], dl
    
    ; Incrementar contador
    inc r14
    jmp .loop_codificar
    
.agregar_iguales:
    ; Reemplazar los últimos caracteres con '=' según sea necesario
    cmp r12, 0
    je .finalizar
    
    mov rax, 4
    sub rax, r12            ; índice donde comienzan los '='
    
.loop_iguales:
    cmp r12, 0
    je .finalizar
    
    mov byte [rbx + rax], '='
    inc rax
    dec r12
    jmp .loop_iguales
    
.finalizar:
    ; Agregar null terminator
    mov byte [rbx + 4], 0
    
    ; Retornar puntero a resultado
    mov rax, rbx
    
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
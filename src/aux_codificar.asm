;;;  Codificacion de Bytes a Caracteres en BASE64

section .data
    tabla_imprimibles   db  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", 0

section .bss
    resultado   resb    4

section .text
    global codificar
codificar:
    push rbx

    lea r8,[rel tabla_imprimibles] ;; Direccion al principio de la tabla
    lea r9,[rel resultado] ;; Registro para ir avanzando sobre los caracteres

    xor rax, rax    ;; Pone en 0 el rax
    mov al, byte [rdi] 
    shl rax, 8
    mov al, byte [rdi + 1]  ; Segundo byte
    shl rax, 8
    mov al, byte [rdi + 2]

    ;; Primeros 6 bits
    mov rbx,rax
    shr rbx,18
    and rbx,0x3F
    mov dl, byte [r8 + rbx]
    mov [r9],dl

    ;; Segundos 6 bits
    mov rbx,rax
    shr rbx,12
    and rbx,0x3F
    mov dl, byte [r8 + rbx]
    mov [r9+1],dl

    ;; Terceros 6 bits
    mov rbx,rax
    shr rbx,6
    and rbx,0x3F
    mov dl, byte [r8 + rbx]
    mov [r9+2],dl

    ;; Ultimos 6 bits
    mov rbx,rax
    and rbx,0x3F
    mov dl, byte [r8 + rbx]
    mov [r9+3],dl

    lea rax,[rel resultado]
    pop rbx
fin:
    ret
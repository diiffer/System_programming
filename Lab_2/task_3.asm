format ELF

public _start

section '.data' writeable
    CHAR = '8'
    char_buf db 0
    newline db 0xA

section '.text' executable
_start:
    mov ebp, 1              ; Номер строки (и кол-во символов в ней)

triangle_loop:
    mov edi, ebp            ; Внутренний счетчик

print_chars:
    mov [char_buf], CHAR
    
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 0x80
    
    dec edi
    jnz print_chars
    
    ; Перевод строки
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    inc ebp
    cmp ebp, 7              ; 1+2+3+4+5+6 = 21 символ. Следующая строка была бы 7.
    jne triangle_loop

    ; Завершение
    mov eax, 1
    xor ebx, ebx
    int 0x80
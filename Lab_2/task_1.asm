format ELF
public _start

section '.data' writeable
    msg db "dKGuxAlwQQtuoxTSEQhjxGKc"
    msg_len = $ - msg
    char_buf db 0
    newline db 0xA

section '.text' executable
_start:
    mov esi, msg_len - 1
    mov edi, msg_len

reverse_loop:
    mov al, [msg + esi]
    mov [char_buf], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 0x80
    
    dec esi
    dec edi
    jnz reverse_loop

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
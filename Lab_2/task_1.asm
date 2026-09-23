format ELF
public _start

section '.data' writeable
    msg db "Assembly"       ; Заданная строка
    msg_len = $ - msg       ; Её длина
    char_buf db 0           ; Буфер для одного символа
    newline db 0xA          ; Перевод строки

section '.text' executable
_start:
    mov esi, msg_len - 1    ; Индекс последнего символа
    mov edi, msg_len        ; Счетчик циклов

reverse_loop:
    mov al, [msg + esi]     ; Берем символ с конца
    mov [char_buf], al      ; Кладем в буфер
    
    ; Системный вызов sys_write (вывод символа)
    mov eax, 4
    mov ebx, 1              ; stdout
    mov ecx, char_buf
    mov edx, 1
    int 0x80
    
    dec esi                 ; Уменьшаем индекс
    dec edi                 ; Уменьшаем счетчик
    jnz reverse_loop        ; Повторяем, если не ноль

    ; Вывод перевода строки в конце
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Завершение программы (sys_exit)
    mov eax, 1
    xor ebx, ebx
    int 0x80
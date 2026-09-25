format ELF
public _start

section '.data' writeable
    ROWS = 8
    COLS = 17
    CHAR = '&'
    buffer db ROWS * COLS dup 0 ; Буфер для заполнения
    newline db 0xA
    char_buf db 0

section '.text' executable
_start:
    ; 1. Заполнение памяти заданным символом
    mov edi, buffer
    mov ecx, ROWS * COLS
    mov al, CHAR
    rep stosb               ; Заполняем буфер

    ; 2. Вывод матрицы
    mov ebp, ROWS           ; Счетчик строк

print_row:
    mov edi, COLS           ; Счетчик столбцов
print_col:
    mov [char_buf], CHAR
    
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 0x80
    
    dec edi
    jnz print_col
    
    ; Перевод строки
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    dec ebp
    jnz print_row

    ; Завершение
    mov eax, 1
    xor ebx, ebx
    int 0x80
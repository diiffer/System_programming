format ELF
public _start

section '.data' writeable
    num_str db "4693338485", 0   ; Заданное число
    res_str db 16 dup 0     ; Буфер для результата
    newline db 0xA

section '.text' executable
_start:
    ; 1. Подсчет суммы цифр
    mov esi, num_str
    xor ebx, ebx            ; ebx = 0 (сумма)

sum_loop:
    mov al, [esi]
    test al, al
    jz sum_done             ; Конец строки
    
    sub al, '0'             ; ASCII -> число
    add bl, al
    inc esi
    jmp sum_loop

sum_done:
    ; 2. Преобразование суммы (в bl) в строку
    movzx eax, bl           ; Переносим сумму в eax
    mov edi, res_str + 15   ; Указатель на конец буфера
    mov byte [edi], 0       ; Null-терминатор
    mov cl, 10

conv_loop:
    dec edi
    xor edx, edx
    div ecx                 ; eax = eax / 10, edx = остаток
    add dl, '0'             ; Остаток -> ASCII
    mov [edi], dl
    test eax, eax
    jnz conv_loop

    ; 3. Вывод результата
    mov edx, res_str + 15
    sub edx, edi            ; Вычисляем длину строки
    
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    int 0x80

    ; Вывод перевода строки
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Завершение
    mov eax, 1
    xor ebx, ebx
    int 0x80
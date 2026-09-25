format ELF
public _start

section '.data' writeable
    K = 136             ; Размер буфера (всего символов)
    CHAR = '&'          ; Заданный символ
    char_buf db 0       ; Буфер для одного символа
    newline db 0xA      ; Символ перевода строки

section '.text' executable
_start:
    mov esi, 0          ; esi = всего выведено символов (наш общий счетчик)
    mov ebp, 1          ; ebp = номер строки (и желаемое кол-во символов в ней)

outer_loop:
    ; Вычисляем, сколько символов вывести в текущей строке
    mov edi, ebp        ; edi = желаемое количество (1, 2, 3...)
    mov eax, esi
    add eax, edi        ; eax = сколько будет всего, если вывести полную строку
    cmp eax, K
    jbe print_full_row  ; Если не превышаем K, выводим полную строку
    
    ; Иначе (если превышаем), выводим только остаток до конца буфера
    mov edi, K
    sub edi, esi        ; edi = K - esi (ровно столько, сколько осталось)

print_full_row:
    ; Внутренний цикл: вывод символов одной строки
    ; edi используется как счетчик цикла
print_chars:
    mov [char_buf], CHAR
    
    ; Системный вызов sys_write
    mov eax, 4          ; номер вызова
    mov ebx, 1          ; stdout
    mov ecx, char_buf   ; адрес символа
    mov edx, 1          ; длина = 1 байт
    int 0x80
    
    inc esi             ; увеличиваем общий счетчик выведенных символов
    dec edi             ; уменьшаем счетчик символов в текущей строке
    jnz print_chars     ; если в строке остались символы, продолжаем
    
    ; Вывод символа перевода строки после каждой строки треугольника
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    ; Проверяем, вывели ли мы ВЕСЬ буфер
    cmp esi, K
    jge done            ; если вывели K символов, завершаем программу
    
    inc ebp             ; увеличиваем длину следующей строки на 1
    jmp outer_loop      ; переходим к следующей строке

done:
    ; Завершение программы
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; код возврата 0
    int 0x80
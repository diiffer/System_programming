format ELF64
public _start
msg1 db "Steperenkov", 0xA, 0
msg2 db "Vladimir", 0xA, 0
msg3 db "Viycheslavovich", 0xA, 0

_start:
    ;инициализация регистров для вывода информации на экран
    mov rax, 4
    mov rbx, 1
    mov rcx, msg1
    mov rdx, 20
    mov rcx, msg2
    mov rdx, 20
    mov rcx, msg3
    mov rdx, 20
    int 0x80
    ;инициализация регистров для успешного завершения работы программы
    mov rax, 1
    mov rbx, 0
    int 0x80
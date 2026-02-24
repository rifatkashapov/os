print_string:
    pusha

start:
    mov al, [bx]
    cmp al, 0
    je end
    mov ah, 0x0e
    int 0x10
    inc bx ; or add bx, 1
    jmp start

end:
    popa
    ret


print_new_line:
    pusha

    mov ah, 0x0e ; teletype output
    mov al, 0x0d ; carriage return
    int 0x10 ; print carriage return
    mov al, 0x0a ; line feed
    int 0x10

    popa
    ret
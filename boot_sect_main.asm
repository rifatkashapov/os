[org 0x7c00]

mov bx, HELLO
call print_string

call print_new_line

mov bx, GOODBEYE
call print_string

call print_new_line

jmp $

%include "boot_sect_print.asm"

HELLO:
    db 'BolgenOS 2: return legacy...', 0

GOODBEYE:
    db 'Goodbye, World!', 0

times 510-($-$$) db 0
dw 0xaa55
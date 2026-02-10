mov ah, 0x0e ; tty mode

mov bp, 0x8000 ; this is an address far away from 0x7c00 so that we don't get overwritten
mov sp, bp ; if the stack is empty then sp points to bp

push 'A'
push 'B'
push 'C'

pop bx ; Note , we can only pop 16 - bits , so pop to bx
mov al, bl ; then copy bl ( i.e. 8 - bit char ) to al
int 0x10 ; print ( al )

pop bx
mov al, bl
int 0x10

mov al , [0x7ffe] ; To prove our stack grows downwards from bp ,
                    ; fetch the char at 0 x8000 - 0 x2 ( i.e. 16 - bits )
int 0x10 ; print ( al )

my_string:
    db "Booting OS", 0

jmp $
times 510-($-$$) db 0
dw 0xaa55
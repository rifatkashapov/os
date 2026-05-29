; GDT = Global Descriptor Table
gdt_start:

gdt_null: ; null descriptor, required by x86 architecture
    dd 0x0 ; 4 bytes for the base (ignored for null descriptor)
    dd 0x0 ; 4 bytes for the limit and flags (ignored for null

gdt_code: ; code segment descriptor
    ; base =0 x0 , limit =0 xfffff ,
    ; 1 st flags : ( present )1 ( privilege )00 ( descriptor type )1 -> 1001 b
    ; type flags : ( code )1 ( conforming )0 ( readable )1 ( accessed )0 -> 1010 b
    ; 2 nd flags : ( granularity )1 (32 - bit default )1 (64 - bit seg )0 ( AVL )0 -> 1100 b
    dw 0xffff ; limit (ignored in protected mode with 32-bit segments) bits 0-15
    dw 0x0 ; base bits 0-15
    db 0x0 ; base bits 16-23
    db 10011010b ; access byte
    db 11001111b ; flags and limit bits 16-19
    db 0x0 ; base bits 24-31

gdt_data: ; data segment descriptor
    ; Same as code segment except for the type flags :
    ; type flags : ( code )0 ( expand down )0 ( writable )1 ( accessed )0 -> 0010 b
    dw 0xffff ; limit (ignored in protected mode with 32-bit segments) bits 0-15
    dw 0x0 ; base bits 0-15
    db 0x0 ; base bits 16-23
    db 10010010b ; access byte
    db 11001111b ; flags and limit bits 16-19
    db 0x0 ; base bits 24-31

gdt_end:    ; The reason for putting a label at the end of the
            ; GDT is so we can have the assembler calculate
            ; the size of the GDT for the GDT decriptor ( below )

gdt_descriptor:
    dw gdt_end - gdt_start - 1      ; Size of our GDT , always less one
                                    ; of the true size
    dd gdt_start                    ; Start address of our GDT

; Define some handy constants for the GDT segment descriptor offsets , which
; are what segment registers must contain when in protected mode. For example ,
; when we set DS = 0 x10 in PM , the CPU knows that we mean it to use the
; segment described at offset 0 x10 ( i.e. 16 bytes ) in our GDT , which in our
; case is the DATA segment (0 x0 -> NULL ; 0 x08 -> CODE ; 0 x10 -> DATA )
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
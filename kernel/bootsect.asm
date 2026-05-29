[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; the offset where the kernel will be loaded in memory (0x1000 = 4096 bytes)

    mov [BOOT_DRIVE], dl ; save the boot drive number for later use

    mov bp, 0x9000 ; 
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print_string ; print a message to indicate that we are in real mode

    call print_new_line

    call load_kernel

    call switch_to_pm

    jmp $

%include "../boot_sect/boot_sect_print.asm"
%include "../boot_sect/boot_sect_print_hex.asm"
%include "../boot_sect/boot_sect_disk.asm"
%include "../protect_mode/32bit-gdt.asm"
%include "../protect_mode/32bit-print.asm"
%include "../protect_mode/32bit-switch.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string

    mov bx, KERNEL_OFFSET ; where we will load the kernel
    mov dh, 15
    mov dl, [BOOT_DRIVE] ; get the boot drive number from where we loaded the boot sector
    call disk_load ; load the kernel from disk into memory at KERNEL_OFFSET

    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm ; print a message to indicate that we are in protected mode

    call KERNEL_OFFSET ; jump to the kernel entry point (which is at KERNEL_OFFSET)

    jmp $

; global variables
BOOT_DRIVE: db 0 ; to store the boot drive number for later use
MSG_REAL_MODE: db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE: db "Successfully landed in 32-bit Protected Mode!", 0
MSG_LOAD_KERNEL: db "Loading kernel into memory...", 0

times 510-($-$$) db 0
dw 0xaa55 ; boot signature
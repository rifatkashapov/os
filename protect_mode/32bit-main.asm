[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; the offset where our kernel will be loaded in memory

    mov [BOOT_DRIVE], dl ; store the boot drive number in a variable for later use

    mov bp, 0x9000 ; set the stack segment to 0x9000
    mov sp, bp ; set the stack pointer to the top of the stack

    mov bx, MSG_REAL_MODE ; es:bx = 0x0000:MSG_REAL_MODE, where our message is locateds
    call print_string ; call the function to print the message in real mode

    call load_kernel ; call the function to load our kernel into memory

    call switch_to_pm ; call the function to switch to protected mode
    jmp $ ; infinite loop to prevent the CPU from executing random instructions after our code

%include "../boot_sect/boot_sect_print.asm"
%include "../boot_sect/boot_sect_disk.asm"
%include "32bit-gdt.asm"
%include "32bit-print.asm"
%include "32bit-switch.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string ; print the message about loading the kernel

    mov bx, KERNEL_OFFSET
    mov dh, 15 ; number of sectors to read (15 sectors = 7.5 KB, which is enough for a simple kernel)
    call disk_load ; read the kernel from the disk into memory at KERNEL_OFFSET
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE ; ebx = address of our message in protected mode
    call print_string_pm ; call the function to print the message in protected mode

    call KERNEL_OFFSET ; jump to the kernel that we loaded into memory

    jmp $ ; infinite loop to prevent the CPU from executing random instructions after our code

BOOT_DRIVE db 0 ; variable to store the boot drive number
MSG_REAL_MODE: db 'Started in 16-bit mode', 0
MSG_PROT_MODE: db 'Loaded 32-bit protected mode', 0
MSG_LOAD_KERNEL: db 'Loading kernel... into memory', 0

times 510-($-$$) db 0
dw 0xaa55
[org 0x7c00]


mov bp, 0x8000 ; set the stack segment to 0x8000
mov sp, bp ; set the stack pointer to the top of the stack

mov bx, 0x9000 ; es:bx = 0x0000:0x9000, where we will load the second stage of our bootloader
mov dh, 2 ; we will read 2 sectors (512 bytes each) to load the second stage
; the bios sets 'dl' for our boot disk number
; if you have trouble, use the '-fda' flag: 'qemu -fda file.bin'
call disk_load ; call the function to load the second stage from disk

mov dx, [0x9000] ; retrieve the first loaded word, 0xdada
call print_hex ; print the magic number in hexadecimal to verify that we loaded the second stage correctly

call print_new_line

mov dx, [0x9000 + 512]
call print_hex ; first word from second loaded sector 0xface

jmp $

%include "boot_sect_print.asm"
%include "boot_sect_print_hex.asm"
%include "boot_sect_disk.asm"

times 510-($-$$) db 0
dw 0xaa55

; boot sector = sector 1 of cyl 0 of head 0 of hdd 0
; from now on = sector 2 ...

times 256 dw 0xdada ; fill the second stage with the magic number 0xdada for testing purposes
times 256 dw 0xface ; fill the third stage with the magic number 0xface for testing purposes
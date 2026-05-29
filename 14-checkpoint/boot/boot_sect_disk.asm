disk_load:
    pusha ; save all registers
    ; reading from disk requires setting specific values in all registers
    ; so we will overwrite our input parameters from 'dx'. Let's save it
    ; to the stack for later use.
    push dx

    mov ah, 0x02 ; 0x02 is the "read sectors" function of the BIOS disk interrupt
    mov al, dh ; number of sectors to read, we will read 'dh' sectors (0x01 .. 0x80)
    mov cl, 0x02 ; sector number to read, we will read from sector 2 (0x01 is the boot sector)
    mov ch, 0x00 ; ch <- cylinder (0x0 .. 0x3FF, upper 2 bits in 'cl')
    ; dl <- drive number. Our caller sets it as a parameter and gets it from BIOS
    ; (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
    mov dh, 0x00 ; head number to read, we will read from head 0 (0x00 .. 0xFF)

    int 0x13 ; call the BIOS disk interrupt to read the sector
    jc disk_error ; if the carry flag is set, there was an error

    pop dx ; restore 'dx' to return the drive number to the caller
    cmp al, dh ; check if we read the correct number of sectors
    jne sectors_error; if not, there was an error
    popa ; restore all registers
    ret

disk_error:
    ; handle disk error (for simplicity, we will just print an error message and halt)
    mov bx, DISK_ERROR
    call print_string
    call print_new_line
    mov dh, ah ; save the error code in 'dh' for debugging purposes
    call print_hex ; print the error code in hexadecimal
    jmp disk_loop

sectors_error:
    ; handle sector error (for simplicity, we will just print an error message and halt)
    mov bx, SECTORS_ERROR
    call print_string

disk_loop:
    jmp $ ; infinite loop to halt the system

DISK_ERROR:
    db 'Disk read error!', 0
SECTORS_ERROR:
    db 'Incorrect number of sectors read!', 0
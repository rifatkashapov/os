[bits 16]
switch_to_pm:
    cli ; 1. disable interrupts before switching to protected mode
    lgdt [gdt_descriptor] ; 2. load the GDT with our GDT descriptor
    mov eax, cr0 ; 3. read the current value of cr0 into eax
    or eax, 0x1 ; 4. set the PE (Protection Enable) bit (bit 0) in eax
    mov cr0, eax ; 5. write the modified value back to cr0 to enable protected mode
    
    jmp CODE_SEG:init_pm ; 6. far jump to the protected mode entry point to flush the instruction pipeline

[bits 32]
init_pm:
    mov ax, DATA_SEG ; 7. set up the data segment registers to point to our data segment in the GDT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov dword [0xb8000], 0x0f410f41
    mov ebp, 0x90000 ; 8. set up the stack pointer to point to the top of our stack (we can use the same memory we used for the stack in real mode)
    mov esp, ebp ; set the stack pointer to the top of the stack

    call BEGIN_PM ; 9. call the main function for our protected mode code
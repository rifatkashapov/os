[bits 32] 

VIDEO_MEMORY: equ 0xb8000
WHITE_ON_BLACK: equ 0x0f ; color attribute for white text on black background

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY ; point to the start of video memory

print_string_pm_loop:
    mov al, [ebx] ; [ebx] is the address of our character
    mov ah, WHITE_ON_BLACK ; set the color attribute

    cmp al, 0 ; check for null terminator
    je print_string_pm_done

    mov [edx], ax ; store character + attribute in video memory
    add ebx, 1 ; move to the next character
    add edx, 2 ; move to the next character cell (2 bytes per cell)
    
    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret
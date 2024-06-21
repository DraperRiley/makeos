.code32 # using 32-bit protected mode

# this is how constants are defined


.section .data
VIDEO_MEMORY: .quad 0xb8000
WHITE_ON_BLACK: .byte 0x0f # the color byte for each character
TEST: .asciz "Is this compiled"

.section .text

.globl _print_string_pm
.type _print_string_pm, @function

_print_string_pm:
    pusha
    mov VIDEO_MEMORY, %edx

print_string_pm_loop:
		mov (%ebx), %al # [ebx] is the address of our character
		mov WHITE_ON_BLACK, %ah

    cmp %al, 0 # check if end of string
    je print_string_pm_done

		mov %ax, (%edx) # store character + attribute in video memory
		add 1, %ebx
		add 2, %edx

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret

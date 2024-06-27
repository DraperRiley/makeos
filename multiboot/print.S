.code32 # using 32-bit protected mode

.section .data
vmem: .long 0xB8000
grey: .byte 0x07 # the color byte for each character

terminal_index: .long 0xB8000

vga_width: .long 80
VGA_HEIGHT: .byte 25
LIGHT_GREY: .byte 7
BLACK: .byte 0
TERM_COLOR: .byte 0

.section .text

.globl _print_string_pm
.type _print_string_pm, @function

_print_string_pm:
		pusha
    mov terminal_index, %edx # vmem address
		mov $0, %ecx # counter for terminal index
		jmp print_string_pm_loop

print_string_pm_loop:
		movb (%ebx), %al
		movb grey, %ah

    cmpb $0, %al # check if end of string
    je print_string_pm_done

		# mov %ax, (%edx) # store character + attribute in video memory
		movb %al, (%edx)
		movb %ah, 1(%edx)	

		add $1, %ebx
		add $2, %edx
		inc %ecx

    jmp print_string_pm_loop

print_string_pm_done:

		mov vga_width, %edx
		sub %ecx, %edx
		shl $1, %edx
		add %edx, terminal_index

    popa
    ret


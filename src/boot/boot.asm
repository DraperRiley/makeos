org 0x7c00
bits 16

; begin
	section .text
	; start at entry
	global _entry
	; extern _KernelMain

_kernel_addr:
	dw 0x8c00

_entry:

	; clear interrupts
	cli
	
	; TODO: enable A20 line

	; set gdt
	call set_gdt

	; go protected mode
	bits 32
	; TODO: set protected mode

	; enter kernel.c
        ; call _KernelMain
	call _kernel_addr

	; should not end up here
	jmp .loop

.loop:
	;oops
	cli
	hlt
	jmp .loop

GDT:
set_gdt:
	; configure gdt
	xor eax, eax
	mov ax, ds
	shl eax, 4
	add eax, GDT
	mov [gdtr + 2], eax
	mov eax, GDT_end
	sub eax, GDT
	mov [gdtr], ax
	lgdt [gdtr]
	ret

gdtr:
	dw 0
	dw 0

GDT_end:

times 510 - ($-$$) db 0
dw 0xAA55

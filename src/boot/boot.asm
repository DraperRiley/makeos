bits 16

; begin
section .text
	; start at entry
	global _entry
	extern _KernelMain

_entry:

	; clear interrupts
	cli
	
	; get ready
	mov ax, 0
	mov ds, ax
	mov es, ax

	; stack
	mov ss, ax
	mov sp, 0x7C00

	; enter kernel.c
        call _KernelMain

	; should not end up here
	jmp loop

.loop:
	; oops
	cli
	hlt
	jmp .loop

times 510 - ($-$$) db 0
dw 0xAA55

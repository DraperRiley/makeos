[org 0x7E00]
[bits 32]

; We expect that this code has been loaded at 0x7E00
; The output of this will be a raw binary

; This is the linked C part of the bootloader
extern _StageTwo

stage2:

	; Call a print here for debugging
	mov ebx, msg
        call print_string_pm	

	; TODO: Jump to function defined in C!

	; If we hit here thats bad
	.halt:
	cli
	hlt
	jmp .halt

%include "32bit-print.asm"

msg: db 'Entering C code area', 0x0a, 0

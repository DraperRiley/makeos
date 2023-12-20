[bits 16]
[org 0x7C00]

%include "headers.asm"

start:
	cli            ; clear interrupts
	mov ax, 0      ; set accumulator to zero first
        mov ds, ax
	mov ax, 0
        mov es, ax

        mov sp, 0x7C00 ; set stack
        mov ss, ax
        call main

%include "gdt.asm"
%include "print.asm"
%include "enablea20.asm"
%include "getlm.asm"

main:
	call reset_screen
	call reset_cursor_total
        call get_lm     ; get lower memory
        call enable_a20 ; enable a20 line

        mov si, msg
        call print

	call reset_cursor

	mov si, msg2
	call print

	call real_to_prot

        jmp .halt       ; shouldnt end up here

.halt:                  ; oops
        cli             ; clear interrupts
        hlt             ; halt cpu
        jmp .halt       ; loop forever

%include "protmode.asm"

[bits 32]
prot_mode:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp
	
.halt
	cli
	hlt
	jmp .halt

msg: db 'Booting into kernel', 0x0a, 0
msg2: db 'Entering protected mode', 0x0a, 0

times 510 - ($-$$) db 0
dw 0xAA55

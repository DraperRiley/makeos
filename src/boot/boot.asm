org 0x7c00
bits 16

start:
	cli            ; clear interrupts
	mov ax, 0      ; set accumulator to zero first
        mov ds, ax
        mov es, ax

        mov sp, 0x7C00 ; set stack
        mov ss, ax
        call main

print:
	
	.loop:
	lodsb
	or al, al
	jz .done

	mov ah, 0x0e
	mov bh, 0x0
	int 0x10
	jmp .loop

	.done:  
	pop ax
	pop si
	ret
		

initreg:
	mov ax, 0
	mov ds, ax ; data segment
	mov es, ax ; e segment?
        mov ss, ax ; stack segment
	ret

get_lm:                    ; GET LOWER MEMORY (AX = total number of KB)
	clc                ; clear carry
	int 0x12           ; bios interrupt (= request low memory size)
	jc main.halt       ; we hit an error :(
	mov [lm_size], ax  ; store ax contents in lm_size
	ret                ; return

lm_size:
	dw 0

GDT:
set_gdt:
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

main:
        call get_lm  ; get lower memory
        ; TODO: enable A20 line
        call set_gdt ; set GDT

        mov si, msg  ; push msg
        call print   ; print

        mov si, msg
        call print

        jmp .halt    ; shouldnt end up here

.halt:               ; oops
        cli          ; clear interrupts
        hlt          ; halt cpu
        jmp .halt    ; loop forever


msg: dw 'First Stage', endl, 0
endl: db 0x0A

times 510 - ($-$$) db 0
dw 0xAA55

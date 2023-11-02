bits 16
org 0x7C00

jmp start

GDT:
	dd 0x00000000 ;Descriptor 0 Null
	dd 0x00000000
	dw 0xffff ;Descriptor 1 Code
	dw 0x0000
	db 0x00
	db 10011010b
	db 11001111b
	db 0x00
	dw 0xffff ;Descriptor 2 Data
	dw 0x0000
	db 0x00
   	db 10010010b
   	db 11001111b
   	db 0x00
GDT_end:

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

get_lm:                    ; GET LOWER MEMORY (AX = total number of KB)
	clc                ; clear carry
	int 0x12           ; bios interrupt (= request low memory size)
	jc main.halt       ; we hit an error :(
	mov [lm_size], ax  ; store ax contents in lm_size
	ret                ; return

lm_size:
	dw 0

enable_a20:
	pushf
	push si
	push di
	push ds
	push es
	cli

	mov ax, 0x0000
	mov ds, ax
	mov si, 0x0500

	not ax
	mov es, ax
	mov di, 0x0510

	mov al, [ds:si]
	mov byte [.BufferBelowMB], al
	mov al, [es:di]
	mov byte [.BufferOverMB], al

	mov ah, 1
	mov byte [ds:si], 0
	mov byte [es:di], 1
	mov al, [ds:si]
	cmp al, [es:di]
	jne .exit
	dec ah

	.exit:
	mov al, [.BufferBelowMB]
	mov [ds:si], al
	mov al, [.BufferOverMB]
	mov [es:di], al
	shr ax, 8
	sti
	pop es
	pop ds
	pop di
	pop si
	popf
	ret

	.BufferBelowMB: db 0
	.BufferOverMB: db 0

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

real_to_prot:
	mov eax, cr0
	or al, 1
	mov cr0, eax
	ret

main:
        call get_lm     ; get lower memory
        call enable_a20 ; enable a20 line
        call set_gdt    ; set GDT

        mov si, msg
        call print

	call real_to_prot ; 32 bits
	bits 32
	
	; TODO: search disk sectors for stage2
	; jmp stage2_addr

        jmp .halt       ; shouldnt end up here

.halt:                  ; oops
        cli             ; clear interrupts
        hlt             ; halt cpu
        jmp .halt       ; loop forever


msg: db 'First Stage', 0

times 510 - ($-$$) db 0
dw 0xAA55

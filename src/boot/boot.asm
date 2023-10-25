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
	
	; init registers
	call init_reg;

	; get amt of lower memory
	call get_lm

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

.loop:             ; oops
	cli        ; clear interrupts
	hlt        ; halt cpu
	jmp .loop  ; loop forever

init_reg:
	xor ax, ax
	mov es, ax
	mov ds, ax
	ret

get_lm:                    ; GET LOWER MEMORY (AX = total number of KB)
	clc                ; clear carry
	int 0x12           ; bios interrupt (= request low memory size)
	jc _entry.loop     ; we hit an error :(
	mov [lm_size], ax  ; store ax contents in lm_size
	ret                ; return

lm_size:
	dw 0

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

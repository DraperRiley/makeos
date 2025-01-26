# ISR stub stuff
.code64

.macro isr_err_stub p
isr_stub_\p:
	pushq $\p
	call general_handler
	iretq
.endm

.macro isr_no_err_stub p
isr_stub_\p:
	pushq $\p
	call general_handler
	iretq
.endm

.macro set_stub p
	.quad isr_stub_\p
.endm

.extern general_handler
isr_no_err_stub 0
isr_no_err_stub 1
isr_no_err_stub 2
isr_no_err_stub 3
isr_no_err_stub 4
isr_no_err_stub 5
isr_no_err_stub 6
isr_no_err_stub 7
isr_err_stub    8
isr_no_err_stub 9
isr_err_stub    10
isr_err_stub    11
isr_err_stub    12
isr_err_stub    13
isr_err_stub    14
isr_no_err_stub 15
isr_no_err_stub 16
isr_err_stub    17
isr_no_err_stub 18
isr_no_err_stub 19
isr_no_err_stub 20
isr_no_err_stub 21
isr_no_err_stub 22
isr_no_err_stub 23
isr_no_err_stub 24
isr_no_err_stub 25
isr_no_err_stub 26
isr_no_err_stub 27
isr_no_err_stub 28
isr_no_err_stub 29
isr_err_stub    30
isr_no_err_stub 31

.globl isr_stub_table

.altmacro

.set i, 0
isr_stub_table:
.rept 32
	set_stub %i
	.set i, i+1
.endr

# End IDT ASM

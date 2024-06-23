// MultiBoot Header
.code32

.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .bss
.align 16
stack_bottom:
.skip 16384
stack_top:

.section .data
msg: .asciz "Initializing system" 
idt_msg: .asciz "Setting up IDT"

.section .text

.global _start
.type _start, @function

.globl _print_string_pm
.type _print_string_pm, @function

#.globl terminal_initialize
#.type terminal_initialize, @function

_start:

	cli
	mov $0, %eax
	mov $0, %ebx
	mov $0, %ecx
	mov $0, %edx

	# Print to screen
	mov $msg, %ebx
	call _print_string_pm

	# Setup IDT
	mov $idt_msg, %ebx
	call _print_string_pm

	# Setup Paging

#.code64
	mov $stack_top, %esp
	# call kernel_main

	cli
1:
	hlt
	jmp 1b


.size _start, . - _start

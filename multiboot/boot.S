// MultiBoot Header
.code32

.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot.header, "aw"
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .multiboot.bss, "aw", @nobits
.align 16
stack_bottom:
.skip 16384
stack_top:

.section .multiboot.data
msg: .asciz "Initializing system" 
pg_msg: .asciz "Setting up paging"
gdt_msg: .asciz "Setting up GDT"
long_msg: .asciz "Jumping to long mode"

.section .multiboot.text, "a"
.global _start
.type _start, @function

.globl _print_string_pm
.type _print_string_pm, @function

#.globl kernel_main
#.type kernel_main, @function

_start:

	cli
	mov $0, %eax
	mov $0, %ebx
	mov $0, %ecx
	mov $0, %edx

	# Print to screen
	mov $msg, %ebx
	call _print_string_pm

	# Setup Paging
	cli
	mov $pg_msg, %ebx
	call _print_string_pm
	call init_paging
	
	# LGDT 64 BIT
	mov $gdt_msg, %ebx
	call _print_string_pm
	call load_gdt

	mov $long_msg, %ebx
	call _print_string_pm

	# where are we going
	ljmpl $.CODE, $_enter_long_mode


.code64
_enter_long_mode:

	mov $.DATA, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss

	mov $0xB8000, %edi
	mov $0x1F201F201F201F20, %rax
	mov $500, %rcx
	rep stosq

	mov $0x00B8000, %edi
	mov $0x1F6C1F6C1F651F48, %rax
	mov %rax, (%edi)

	mov $stack_top, %rsp
	movabsq $kernel_main, %rax
	jmp *%rax

	cli
1:
	hlt
	jmp 1b


.size _start, . - _start

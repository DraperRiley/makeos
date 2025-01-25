# Load GDT with 64-bit flags
.code32

.section .multiboot.data, "aw"

.set PRESENT, 1 << 7
.set NOT_SYS, 1 << 4
.set EXEC, 1 << 3
.set DC, 1 << 2
.set RW, 1 << 1
.set ACCESSED, 1 << 0

.set GRAN_4K, 1 << 7
.set SZ_32, 1 << 6
.set LONG_MODE, 1 << 5

.section .multiboot.text, "a"

# FROM NASM
# dq = .quad (64 bit)
# db = .byte  (8 bit)
# dd = .int  (32 bit)
# dw = .short (16 bit)

.globl load_gdt
.globl .CODE
.globl .DATA
.globl GDT

GDT:
	# NULL
.set .NULL, . - GDT
	.quad	0
.set .CODE, . - GDT
	.int 0xFFFF
	.byte 0
	.byte PRESENT | NOT_SYS | EXEC | RW
	.byte GRAN_4K | LONG_MODE | 0xF
	.byte 0
	# DATA
.set .DATA, . - GDT 
	.int 0xFFFF
	.byte 0
	.byte PRESENT | NOT_SYS | RW
	.byte GRAN_4K | SZ_32 | 0xF
	.byte 0
	# TSS
.set .TSS, . - GDT
	.int 0x00000068
	.int 0x00CF8900
	# Pointer
.Pointer:
	.short . - GDT - 1 
	.quad GDT

load_gdt:
	lgdt .Pointer
	ret
	

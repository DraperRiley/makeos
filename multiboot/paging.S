.code32

.section .data

.section .text

.globl init_paging

init_paging:

	pusha
	mov $0x1000, %edi
	mov %edi, %cr3
	xor %eax, %eax
	mov $4096, %ecx
	rep stosl
	mov %cr3, %edi
	
	movw $0x2003, (%edi)
	add $0x1000, %edi

	movw $0x3003, (%edi)
	add $0x1000, %edi
	
	movw $0x4003, (%edi)
	add $0x1000, %edi

	mov $0x00000003, %ebx
	mov $512, %ecx

.setEntry:

	mov %ebx, (%edi)
	add $0x1000, %ebx
	add $8, %edi
	loop .setEntry

	mov %cr4, %eax
	or %eax, 1 << 5
	mov %eax, %cr4

	mov $0xC0000080, %ecx
  rdmsr
  or %eax, 1 << 8
  wrmsr

  mov %cr0, %eax
  or %eax, 1 << 31
  mov %eax, %cr0

	popa
	ret



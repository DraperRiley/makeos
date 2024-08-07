.code32

.section .multiboot.text, "a"
.globl init_paging

init_paging:

	pusha

	# Clear tables
	mov $0x1000, %edi
	mov %edi, %cr3
	xor %eax, %eax
	mov $4096, %ecx
	rep stosl
	mov %cr3, %edi
	
	# Set tables
	movw $0x2003, (%edi)
	add $0x1000, %edi

	movw $0x3003, (%edi)
	add $0x1000, %edi
	
	movw $0x4003, (%edi)
	add $0x1000, %edi

	# Identity map first 2MB
	mov $0x00000003, %ebx
	mov $512, %ecx

.setEntry:

	movl %ebx, (%edi)
	add $0x1000, %ebx
	add $8, %edi
	loop .setEntry

	# Identity map HH kernel

	# mov $0xC0100000, %ebx
	# mov $512, %ecx

	# Get top level pt
	#xor %ebx, %ebx
	#mov %cr3, %edi
	#mov (%edi), %ebx
	#mov %ebx, %edi	

	mov $0x2018, %edi
	movw $0x3003, (%edi)

	# Create entry at pt lvl2 + 3 offset

.MapHH:
	
	#movl %ebx, (%edi)
	#add $0x1000, %ebx
	#add $8, %edi
	#loop .MapHH

	mov %cr4, %eax
	or $(1<<5), %eax
	mov %eax, %cr4

	mov $0xC0000080, %ecx
  rdmsr
  or $(1<<8), %eax
  wrmsr

  mov %cr0, %eax
  or $(1<<31), %eax
  mov %eax, %cr0

	popa
	ret



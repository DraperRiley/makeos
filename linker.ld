/* Kernel linker for x86_64
 *
 */

ENTRY(_entry)
OUTPUT_FORMAT(binary)
OUTPUT(kernel.bin)

phys = 0x7C00

SECTIONS 
{

	.text phys : AT(phys) 
	{
		code = .;
		*(.text)
		*(.rodata)
		. = ALIGN(4096);
	}

	.data : AT(phys + (data - code))
	{
		data = .;
		*(.data)
		. = ALIGN(4096);
	}

	.bss : AT(phys + (bss - code))
	{
		bss = .;
		*(.bss)
		. = ALIGN(4096);
	}

	end = .;

	/DISCARD/ :
	{
		*(.comment)
		*(.eh_frame)
		*(.note.gnu.build-id)
	}
}

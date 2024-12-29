#include <stdio.h>

#include "idt.h"

void _lidt(void);
void _iretq(void);

IDTEntry *idt_table;

void idtinit(void *addr)
{
	// lets put this after our kernel
	// so at kernel_end rounded up to the nearest page
	// then increment kernel_end by a page
	idt_table = addr;
	_lidt();
}

void _lidt(void)
{
	asm ("lidt %0"	
			 ::"m" (idt_table)
	);
}

void _iretq(void)
{
	asm ("iretq");
}

#include <stdio.h>

#include "idt.h"

#define IDTSIZE 256

void _lidt(void);
void _iretq(void);
void _ldpgfault(void);
void _pagefaulthandler(void);

// static idtentry_t *idt_table;
__attribute__((aligned(0x10)))
static idtentry_t idt_table[IDTSIZE];
static IDTRecord idtr;

void idtinit(void)
{
	// lets put this after our kernel
	// so at kernel_end rounded up to the nearest page
	// then increment kernel_end by a page
	// load with page fault handler

	_ldpgfault();
	_lidt();
	
}

void _lidt(void)
{
	idtr.offset = (uint64_t) &idt_table[0];
	idtr.size = (uint16_t) IDTSIZE - 1;

	asm volatile ("lidt %0" : : "m"(idtr));
	asm volatile ("sti");
}

void _iretq(void)
{
	asm ("iretq");
}

void _ldpgfault(void)
{
	idtentry_t *idte = &idt_table[0xE];
	idte->offset_1 = (uint64_t) _pagefaulthandler & 0xFFFF;
	idte->selector = 0x08; // 0x00
	idte->ist = 0;
	idte->type_attributes = 0x8E;
	idte->offset_2 = ((uint64_t) _pagefaulthandler >> 16) & 0xFFFF;
	idte->offset_3 = ((uint64_t) _pagefaulthandler >> 32) & 0xFFFFFFFF;
	idte->zero = 0;
}

__attribute__((noreturn))
void _pagefaulthandler(void)
{
	printf("HIT PAGE FAULT!!\n");
	asm volatile ("cli; hlt");
	_iretq();
}


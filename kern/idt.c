#include <stdio.h>

#include "idt.h"

#define IDTSIZE 32

// Function prototyping
void lidt(void);
void general_handler(void);
void ld_descriptor(uint8_t, void*);
void ld_table(void);

// Global vars
__attribute__((aligned(0x10)))
static idtentry_t idt_table[IDTSIZE];
static IDTRecord idtr;
extern void *isr_stub_table[];

void idtinit(void)
{
	ld_table();
	lidt();
}

void lidt(void)
{
	asm volatile ("lidt %0" :: "m"(idtr));
	asm volatile ("sti");
}

void ld_table(void)
{
	idtr.offset = (uint64_t) &idt_table[0];
	idtr.size = (uint16_t) IDTSIZE - 1;

	for(size_t i = 0; i < IDTSIZE; ++i)
	{
		ld_descriptor(i, isr_stub_table[i]);
	}

}

void ld_descriptor(uint8_t dnum, void *isr)
{
	idtentry_t *idte = &idt_table[dnum];
	idte->offset_1 = (uint64_t) isr & 0xFFFF;
	idte->selector = 0x08;
	idte->ist = 0;
	idte->type_attributes = 0x8E;
	idte->offset_2 = ((uint64_t) isr >> 16) & 0xFFFF;
	idte->offset_3 = ((uint64_t) isr >> 32) & 0xFFFFFFFF;
	idte->zero = 0;
}

__attribute__((noreturn))
void general_handler(void)
{
	printf("Fault Encountered\n");
	asm volatile ("cli; hlt");
}


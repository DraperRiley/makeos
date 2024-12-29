#include <stdbool.h>
/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "os.h"
#include "spinlock.h"
#include "idt.h"

void kernel_main(void) 
{
	/* Initialize terminal interface */
	consoleinit(VGA_COLOR_WHITE, VGA_COLOR_BLACK);
	terminit((uint32_t *)VGABUF);
	printf("Console initialized\n");
	printf("Terminal initialized\n");
	printf("Kernel end addr: %x\n", kernel_end);
	//idtinit((uint32_t *)((int32_t)kernel_end + 1));

	// init mem
	

	// panic
	panic("Attempted to exit kernel main");
}

void panic(char *e)
{
	printf("Kernel has panicked %s", e);
	for(;;)
		;
}

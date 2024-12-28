#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "stdlib.h"

/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

void panic(void)
{
	printf("Kernel has panicked");
	for(;;)
		;
}

void kernel_main(void) 
{
	/* Initialize terminal interface */
	consoleinit(VGA_COLOR_WHITE, VGA_COLOR_BLACK);
	terminit((uint32_t *)VGABUF);
	printf("Console initialized\n");
	printf("Terminal initialized\n");

	// panic
	panic();
}

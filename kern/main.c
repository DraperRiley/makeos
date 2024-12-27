#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

#define VGABUF 0xb8000

void panic(void)
{
	printf("Kernel has panicked");
	for(;;)
		;
}

void kernel_main(void) 
{
	/* Initialize terminal interface */
	terminit((uint32_t *)VGABUF);
	printf("Hello, kernel World!\n");
	printf("Initializing...\n");
	printf("We are here\n");

	// panic
	panic();
}

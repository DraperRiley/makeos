#include "kernel.h"

// Kernel Entry
extern void _KernelMain() {
	printf("Hello, World!\n");
}

// Kernel Panic
void panic() {
	printf("Unrecoverable Error, panic!\n");
        for(;;)
		idle();
}

void idle() {
	return;	
}

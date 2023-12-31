#include "kernel.h"

// Kernel Entry
int _start() {
	_KernelMain();
}

extern void _KernelMain() {
	//printf("Hello, World!\n");
}

// Kernel Panic
void panic() {
	// printf("Unrecoverable Error, panic!\n");
        for(;;)
		;
}

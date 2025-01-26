// OS wide functions

// Helper for debugging
#define PAUSE() for(;;);

// Virtual address where kernel ends
// Phys address is this minus 0xC0000000
extern uint64_t kernel_end[];

// General panic and halt
void panic(char *e);

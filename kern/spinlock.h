#include <stdint.h>

typedef struct
{
	uint8_t locked;
	char name[16];
} SpinLock;

void acquire(SpinLock *l);
void release(SpinLock *l);

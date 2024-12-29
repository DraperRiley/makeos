// IDT structs and prototypes
#include <stdint.h>

typedef struct __attribute__((packed))
{
	uint32_t reserved;
	uint32_t offset;
	uint32_t offset2;
	uint16_t segselector;
	uint16_t offset3;
} IDTEntry;

void idtinit(void *addr);

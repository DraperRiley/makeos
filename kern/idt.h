// IDT structs and prototypes
#include <stdint.h>

typedef struct
{
	uint16_t size;
	uint64_t offset;
} __attribute__((packed)) IDTRecord;

typedef struct
{
	uint16_t offset_1;
	uint16_t selector;
	uint8_t ist;
	uint8_t type_attributes;
	uint16_t offset_2;
	uint32_t offset_3;
	uint32_t zero;
} __attribute__((packed)) idtentry_t;

typedef struct __attribute__((packed))
{
	uint64_t ip;
	uint64_t cs;
	uint64_t flags;
	uint64_t sp;
	uint64_t ss;
} InterruptFrame;

void idtinit(void);

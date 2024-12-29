#include <stdlib.h>

// reverse string in place
static void _revstr(char *buf, int st, int end)
{
	char tmp;
	while (st < end)
	{
		tmp = buf[st];
		buf[st++] = buf[end];
		buf[end--] = tmp;
	}	
}

// convert integer to string and fill in place buffer
void itoa(uint64_t value, char *buf, int base)
{
	// string start and end
	uint16_t st, end = 0;
	if (value < 0)
	{
		buf[st++] = '-';
		end++;
		value = ~(value - 1); // reverse two's complement
	}	

	// break down the integer
	while (1)
	{
		buf[end++] = (char)((value % base) + 0x30);
		value /= base;
		if (!value)
			break;
	}

	buf[end--] = '\0';
	_revstr(buf, st, end);
}

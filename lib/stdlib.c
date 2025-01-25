#include <stdlib.h>

#define HEX30 0x30
#define HEX37 0x37

char _basehandle(uint64_t value, uint8_t base);

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
		buf[end++] = _basehandle(value, base);
		value /= base;
		if (!value)
			break;
	}

	buf[end--] = '\0';
	_revstr(buf, st, end);
}

char _basehandle(uint64_t value, uint8_t base)
{
	uint64_t tmp = value % base;
	switch (base)
	{
		case 16:
			if (tmp >= 10)
				tmp += HEX37;
			else
				tmp += HEX30;
			break;

		default:
			tmp += HEX30;
	}
	return (char) tmp;
}


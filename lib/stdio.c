#include "stdio.h"
#include "stdlib.h"

static size_t VGA_WIDTH = 80;
static size_t VGA_HEIGHT = 25;
static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t *buffer;
static const char BUF[256] = {'\0'};

uint8_t vga_entry_color(uint16_t fg, uint16_t bg) 
{
	return fg | (bg << 4);
}

uint16_t vga_entry(unsigned char uc, uint8_t color) 
{
	return (uint16_t) uc | ((uint16_t) color << 8);
}

size_t strlen(const char* str) 
{
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

void consoleinit(uint16_t fg, uint16_t bg)
{
	terminal_color = vga_entry_color(fg, bg);
}

void terminit(void *addr) 
{
	if (!terminal_color)
		terminal_color = vga_entry_color(VGA_COLOR_WHITE, VGA_COLOR_BLUE);

	terminal_row = 0;
	terminal_column = 0;
	buffer = (uint16_t*) addr;

	for (size_t y = 0; y < VGA_HEIGHT * VGA_WIDTH; y++)
		buffer[y] = vga_entry(' ', terminal_color);
}

void terminal_setcolor(uint8_t color) 
{
	terminal_color = color;
}

void _puts(char c) 
{

	switch (c)
	{
		case '\n':
			terminal_column = -1;
			if (++terminal_row >= VGA_HEIGHT)
				terminal_row = 24;
			break;	

		default:
			const size_t index = terminal_row * VGA_WIDTH + terminal_column;
			buffer[index] = vga_entry(c, terminal_color);
	}


	if (++terminal_column >= VGA_WIDTH)
	{ 
		terminal_column = 0;
		if (++terminal_row >= VGA_HEIGHT) 
			terminal_row = 0;
	}
}

void printf(const char* fmt, ...) 
{
	va_list vl;
	va_start(vl, fmt);

	for (size_t i = 0; fmt[i]; i++)
	{
		if (fmt[i] == '%')
		{
			switch (fmt[++i])
			{
				case 'd':
					itoa(va_arg(vl, uint64_t), BUF, 10);
					printf(BUF);
					break;

				case 'x':
					xtoa(va_arg(vl, uint64_t), BUF);
					printf(BUF);
					break;

				case 's':
					printf(va_arg(vl, char *));
					break;
			}
		}
		else
		{
			_puts(fmt[i]);
		}
	}

	va_end(vl);
}

void scroll_terminal(void)
{
	for (size_t y = 1; y < VGA_HEIGHT; ++y)
	{
		size_t line = y * VGA_HEIGHT;
		size_t prev_line = (y-1) * VGA_HEIGHT;
		for (size_t x = 0; x < VGA_WIDTH; ++x)
			buffer[prev_line + x] = buffer[line + x];
	}
}

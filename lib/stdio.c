#include "stdio.h"

static size_t VGA_WIDTH = 80;
static size_t VGA_HEIGHT = 25;
static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t *buffer;

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) 
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

void terminit(void *addr) 
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_WHITE, VGA_COLOR_BLUE);	
	buffer = (uint16_t*) addr;

	for (size_t y = 0; y < VGA_HEIGHT * VGA_WIDTH; y++) {
		buffer[y] = vga_entry(' ', terminal_color);
	}

}

void terminal_setcolor(uint8_t color) 
{
	terminal_color = color;
}

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) 
{

	switch (c)
	{
		case '\n':
			terminal_column = -1;
			if (++terminal_row >= VGA_HEIGHT)
			{
				terminal_row = 24;
			}
			break;	

		default:
			const size_t index = y * VGA_WIDTH + x;
			buffer[index] = vga_entry(c, color);
	}
}

void terminal_putchar(char c) 
{
	terminal_putentryat(c, terminal_color, terminal_column, terminal_row);

	if (++terminal_column >= VGA_WIDTH)
	{ 
		terminal_column = 0;
		if (++terminal_row >= VGA_HEIGHT) 
			terminal_row = 0;
	}

}

void terminal_write(const char* data, size_t size) 
{
	for (size_t i = 0; i < size; i++)
		terminal_putchar(data[i]);
}

void printf(const char* data) 
{
	terminal_write(data, strlen(data));
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

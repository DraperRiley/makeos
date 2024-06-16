#include <efi.h>
#include <efilib.h>

VOID PRINTERR(VOID);
void write_string(int color, const char *string);
void efi_panic(void);

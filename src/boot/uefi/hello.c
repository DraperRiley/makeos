#include <efi.h>
#include <efilib.h>

EFI_STATUS
efi_main (
		EFI_HANDLE image, 
		EFI_SYSTEM_TABLE *system)
{
	InitializeLib(image, system);
	Print(L"Hello World!\n");
	return EFI_SUCCESS;
}

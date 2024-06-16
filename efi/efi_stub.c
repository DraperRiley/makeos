#include "efi_stub.h"

VOID
efi_main (
	EFI_HANDLE ImageHandle,
	EFI_SYSTEM_TABLE *SystemTable)
{
	InitializeLib(ImageHandle, SystemTable);
	Print(L"Booting from EFI stub\r\n");

	// Exit boot services to handle memory ourselves
	// get memory map first

	EFI_STATUS ReturnStatus;

	UINTN MemoryMapSize = 0;
	EFI_MEMORY_DESCRIPTOR *MemoryMap;
	UINTN MapKey = 0;
	UINTN DescriptorSize = 0;
	UINT32 DescriptorVersion = 0;

	// Fill these with what we need
	ReturnStatus = uefi_call_wrapper(
    BS->GetMemoryMap,
    5,
    &MemoryMapSize,
    NULL,
    NULL,
    &DescriptorSize,
    &DescriptorVersion
  );

	Print(L"Descriptor size: %d\r\n", DescriptorSize);
	Print(L"Descriptor version: %d\r\n", DescriptorVersion);
	Print(L"Memory Map Size: %d\r\n", MemoryMapSize);

	// Allocate size for MemMap
	ReturnStatus = uefi_call_wrapper(
		BS->AllocatePool,
		3,
		EfiLoaderData,
		MemoryMapSize,
		(VOID **) &MemoryMap
	);

	switch (ReturnStatus)
	{
		case EFI_SUCCESS:
			Print(L"Memory allocated for memory map\r\n");
			break;

		default:
			Print(L"Error allocating pool\r\n");
	}


	ReturnStatus = uefi_call_wrapper(
		BS->GetMemoryMap,
		5,
		&MemoryMapSize,
		MemoryMap,
		&MapKey,
		&DescriptorSize,
		&DescriptorVersion
	);

	switch (ReturnStatus)
	{
		case EFI_BUFFER_TOO_SMALL:
			Print(L"Buffer is too small\r\n");
			break;

		case EFI_SUCCESS:
			Print(L"Retrieved memory map\r\n");
			Print(L"MapKey: %d\r\n", MapKey);
			break;	
	
		default:
			Print(L"Unknown status\r\n");
	}

	EFI_MEMORY_DESCRIPTOR TempDescriptor;
	TempDescriptor = MemoryMap[0];

	Print(L"Type: %d\r\n", TempDescriptor.Type);
	Print(L"PhysicalStart: %d\r\n", TempDescriptor.PhysicalStart);
	Print(L"VirtualStart: %d\r\n", TempDescriptor.VirtualStart);
	Print(L"NumberOfPages: %d\r\n", TempDescriptor.NumberOfPages);
	Print(L"Attribute: %d\r\n", TempDescriptor.Attribute);

	Print(L"Exiting EFI boot services\r\n");

	ReturnStatus = uefi_call_wrapper(
		BS->ExitBootServices,
		2,
		ImageHandle,
		MapKey
	);

	switch (ReturnStatus)
	{
		case EFI_INVALID_PARAMETER:
			Print(L"ExitBootServices: Invalid parameter\r\n");
			break;
	}

	*((int*)0xb8000)=0x7690748;
	write_string(0xFF, "Test Write\r\n");

	// NULL the SystemTable
	// TODO: NullSystab(&SystemTable);

	Print(L"Test\r\n");
}

VOID
PRINTERR(VOID)
{
	Print(L"Error encountered\r\n");
}

void write_string(int color, const char *string)
{
	volatile char *video = (volatile char*)0xB0000;
	while (*string != 0)
	{
		*video++ = *string++;
		*video++ = color;
	}
}

void efi_panic(void)
{
	write_string(0xFF, "kernel panicked\r\n");
	for(;;)
		;
}

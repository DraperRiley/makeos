#include "efi_stub.h"

VOID
efi_main (
	EFI_HANDLE ImageHandle,
	EFI_SYSTEM_TABLE *SystemTable)
{
	InitializeLib(ImageHandle, SystemTable);
	Print(L"Booting from EFI stub\r\n");

	EFI_STATUS ReturnStatus;

	// Linear Framebuffer
	EFI_GUID GopGuid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
	EFI_GRAPHICS_OUTPUT_PROTOCOL *Gop;

	ReturnStatus = uefi_call_wrapper(
		BS->LocateProtocol,
		3,
		&GopGuid,
		NULL,
		(VOID **) &Gop
	);

	if (EFI_ERROR(ReturnStatus))
		Print(L"Unable to locate GOP\r\n");

	// Get the current mode
	EFI_GRAPHICS_OUTPUT_MODE_INFORMATION *Info;
	UINTN SizeOfInfo, NumModes, NativeMode;

	uefi_call_wrapper(
		Gop->QueryMode,
		4,
		Gop,
		Gop->Mode == NULL ? 0 : Gop->Mode->Mode,
		&SizeOfInfo,
		&Info
	);

	if (ReturnStatus == EFI_NOT_STARTED)
		ReturnStatus = uefi_call_wrapper(
			Gop->SetMode,
			2,
			Gop,
			0
		);

	if (EFI_ERROR(ReturnStatus))
	{
		Print(L"Unable to get native mode\r\n");
	}
	else
	{
		NativeMode = Gop->Mode->Mode;
		NumModes = Gop->Mode->MaxMode;
	}

	// Query available video modes
	for (int i = 0; i < NumModes; ++i)
	{
		ReturnStatus = uefi_call_wrapper(
			Gop->QueryMode,
			4,
			Gop,
			i,
			&SizeOfInfo,
			&Info
		);

		Print(L"Mode %03d Width %d Height %d Format %x%s\r\n",
			i,
			Info->HorizontalResolution,
			Info->VerticalResolution,
			Info->PixelFormat,
			i == NativeMode ? "(current)" : ""
		);
	}

	// Set video mode get framebuffer
	ReturnStatus = uefi_call_wrapper(
		Gop->SetMode,
		2,
		Gop,
		NativeMode
	);

	if (EFI_ERROR(ReturnStatus))
	{
		Print(L"Unable to set mode %03d", NativeMode);
	}
	else
	{
		Print(L"Framebuffer address %x Size %d Width %d Height %d PixelsPerLine %d\r\n",
			Gop->Mode->FrameBufferBase,
			Gop->Mode->FrameBufferSize,
			Gop->Mode->Info->HorizontalResolution,
			Gop->Mode->Info->VerticalResolution,
			Gop->Mode->Info->PixelsPerScanLine
		);
	}

	for (int i = 0; i < 200; ++i)
	{
		*((uint32_t*)(Gop->Mode->FrameBufferBase + 4 * Gop->Mode->Info->PixelsPerScanLine * i + 4 * i)) = 0x11000110;
	}

	// Exit boot services to handle memory ourselves
	// get memory map first

	UINTN MemoryMapSize = 0;
	EFI_MEMORY_DESCRIPTOR *MemoryMap;
	UINTN MapKey;
	UINTN DescriptorSize;
	UINT32 DescriptorVersion;


	// Fill these with what we need
	ReturnStatus = uefi_call_wrapper(
    BS->GetMemoryMap,
    5,
    &MemoryMapSize,
    MemoryMap,
    &MapKey,
    &DescriptorSize,
    &DescriptorVersion
  );
	
	Print(L"Descriptor size: %d\r\n", DescriptorSize);
	Print(L"Descriptor version: %d\r\n", DescriptorVersion);
	Print(L"Required memory map size: %d\r\n", MemoryMapSize);

	MemoryMapSize *= 2;
	Print(L"Allocating: %dB\r\n", MemoryMapSize);

	// Allocate size for MemMap
	ReturnStatus = uefi_call_wrapper(
		BS->AllocatePool,
		3,
		EfiLoaderData,
		MemoryMapSize,
		(VOID **) &MemoryMap
	);

	ReturnStatus = uefi_call_wrapper(
		BS->GetMemoryMap,
		5,
		&MemoryMapSize,
		MemoryMap,
		&MapKey,
		&DescriptorSize,
		&DescriptorVersion
	);

	ReturnStatus = uefi_call_wrapper(
		BS->ExitBootServices,
		2,
		ImageHandle,
		MapKey
	);

	*((int*)0xb8000)=0x7690748;
	UINT32 RetryCount = 0;

	while (EFI_ERROR(ReturnStatus))
	{

		if (RetryCount >= 10)
			break;

		Print(L"Failed to exit boot services: %r\r\n", ReturnStatus);
		Print(L"Attempting to get memory map again...\r\n");

		ReturnStatus = uefi_call_wrapper(
			BS->FreePool,
			1,
			MemoryMap
		);

		if (EFI_ERROR(ReturnStatus))
		{
			Print(L"Unable to free memmap buffer\r\n");
			break;
		}

		MemoryMapSize *= 2;

		uefi_call_wrapper(
			BS->AllocatePool,
			3,
			EfiLoaderData,
			MemoryMapSize,
			(VOID **) &MemoryMap
		);

		if (EFI_ERROR(ReturnStatus))
		{
			Print(L"Unable to allocate pool\r\n");
		}
		else
		{
			ReturnStatus = uefi_call_wrapper(
				BS->GetMemoryMap,
				5,
				&MemoryMapSize,
				MemoryMap,
				&MapKey,
				&DescriptorSize,
				&DescriptorVersion
			);
		}

		if (EFI_ERROR(ReturnStatus))
		{
			Print(L"Failed to retrieve memory map\r\n");
		}
		else
		{
		
			Print(L"Attempting to exit boot services\r\n");
			ReturnStatus = uefi_call_wrapper(
				BS->ExitBootServices,
				2,
				ImageHandle,
				MapKey
			);

		}

		RetryCount++;
	}

	if (EFI_ERROR(ReturnStatus))
		Print(L"Failed to exit boot services after %d attempts\r\n", RetryCount);

	//*((int*)0xb8000)=0x7690748;
	//write_string(0x1F, "Test Write\r\n");

	// NULL the SystemTable
	// TODO: NullSystab(&SystemTable);

	for (int i = 0; i < 200; ++i)
  {
    *((uint32_t*)(Gop->Mode->FrameBufferBase + 4 * Gop->Mode->Info->PixelsPerScanLine * i + 4 * i)) = 0x1F;
  }

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

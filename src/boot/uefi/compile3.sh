INCDIR=/usr/local/include/efi
LIB=/usr/local/lib

gcc	-I$INCDIR \
	-I$INCDIR/x86_64 \
	-I$INCDIR/protocol \
	-nostdlib \
	-fno-stack-protector \
	-fno-strict-aliasing \
	-fno-builtin \
	-fpic \
	-fshort-wchar \
	-mno-red-zone \
	-Wall \
	-c hello.c \
	-o hello.o

#gcc 	-I/home/rdraper/gnu-efi//apps 
#	-I/home/rdraper/gnu-efi//apps/../inc 
#	-I/home/rdraper/gnu-efi//apps/../inc/x86_64 
#	-I/home/rdraper/gnu-efi//apps/../inc/protocol 
#	-Wno-error=pragmas 
#	-mno-red-zone 
#	-mno-avx 
#	-fPIE  
#	-g -O2 
#	-Wall 
#	-Wextra 
#	-Wno-pointer-sign 
#	-Werror 
#	-funsigned-char 
#	-fshort-wchar 
#	-fno-strict-aliasing 
#	-ffreestanding 
#	-fno-stack-protector 
#	-fno-stack-check 
#	-fno-merge-all-constants 
#	-DCONFIG_x86_64 
#	-std=c11 
#	-DGNU_EFI_USE_MS_ABI 
#	-maccumulate-outgoing-args 
#	-D__KERNEL__ 
#	-I/usr/src/sys/build/include 
#	-c hello.c 
#	-o hello.o

# TODO SOMETHING IS WRONG WITH LINKING
ld 	-nostdlib \
	-no-undefined \
	-znocombreloc \
	-shared \
	-Bsymbolic \
	-L $LIB \
	-T $LIB/elf_x86_64_efi.lds \
	$LIB/crt0-efi-x86_64.o \
	hello.o \
	-o hello.so \
	-lefi \
	-lgnuefi

objcopy -j .text \
	-j .sdata \
	-j .data \
	-j .dynamic \
	-j .rodata \
	-j .rel \
	-j .rela \
	-j .rel.* \
	-j .rela.* \
	-j .rel* \
	-j .rela* \
	-j .areloc \
	-j .reloc \
	--target efi-app-x86_64 \
	hello.so hello.efi


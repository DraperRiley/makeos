
UEFI := uefi
LEGACY := legacy
ST2 := stage2
headers = headers

CC = gcc
LD = ld
OBJC = objcopy

OUT := BOOTX64.EFI
ARCH := x86_64
LDS := elf_$(ARCH)_efi.lds
CRT := crt0-efi-$(ARCH).o
SO := out.so

INCDIR := /usr/local/include/efi
LIB := /usr/local/lib

INC :=  -I$(INCDIR) \
        -I$(INCDIR)/$(ARCH) \
        -I$(INCDIR)/protocol

SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)

CCFLAGS = -nostdlib -fno-stack-protector \
        -fno-strict-aliasing -fno-builtin \
        -fpic -fshort-wchar -mno-red-zone \
        -Wall

LDFLAGS := -nostdlib -no-undefined -znocombreloc \
        -shared -Bsymbolic \
        -L $(LIB) \
        -T $(LIB)/$(LDS) \
        $(LIB)/$(CRT) \
        -lefi \
        -lgnuefi
OBJFLAGS := -j .text -j .sdata \
	-j .data -j .dynamic -j .rodata \
        -j .rel -j .rela -j .rel.* -j .rela.* \
        -j .rel* -j .rela* -j .areloc -j .reloc \
        --target efi-app-x86_64

$(OUT): $(SO)
	$(OBJC) $(OBJFLAGS) $< $@

$(SO): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(SO)

$(OBJS): $(SRCS)
	$(CC) -c $< $(INC) $(CCFLAGS) -o $@

always:
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)
	rm -f *.o *.so

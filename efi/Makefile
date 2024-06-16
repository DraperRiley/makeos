# UEFI App Makefile

BUILD := build

UEFI := uefi
LEGACY := legacy
ST2 := stage2
headers = headers

CC = gcc
LD = ld
OBJC = objcopy

#CC := clang
#LD = ld.lld-18

OUT := myOS
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

CFLAGS = $(INC) -nostdlib -fno-stack-protector \
        -fno-strict-aliasing -fno-builtin \
        -fpic -fshort-wchar -mno-red-zone \
        -Wall

LDFLAGS := -nostdlib -no-undefined -znocombreloc \
        -shared -Bsymbolic \
        -L $(LIB) \
        -T $(LIB)/$(LDS) \
        $(LIB)/$(CRT)

#CFLAGS := $(INC) -target $(ARCH)-unknown-windows \
				-ffreestanding \
				-mno-red-zone

#LDFLAGS := -flavor link \
				-subsystem:efi_application \
				-entry:efi_main \
				-libpath:$(LIB) \

# LDFLAGS := -target x86_64-unknown-windows \
				-nostdlib \
				-L $(LIB) \
				-lefi \
				-Wl,-entry:efi_main \
				-Wl,-subsystem:efi_application \
				-fuse-ld=lld-link

IMG := fs.img

ifeq ($(ARCH), x86_64)
	CCFLAGS += -DEFI_FUNCTION_WRAPPER
endif

OBJFLAGS := -j .text -j .sdata \
	-j .data -j .dynamic -j .rodata \
        -j .rel -j .rela -j .rel.* -j .rela.* \
        -j .rel* -j .rela* -j .areloc -j .reloc \
        --target efi-app-x86_64

# Using GCC
$(OUT): $(SO)
	$(OBJC) $(OBJFLAGS) $< $@

$(SO): always $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(SO) -lefi -lgnuefi

# Clang
# $(OUT): $(OBJS) always
#	$(LD) $(LDFLAGS) $(OBJS) -out:$@
#	mv $@ $(BUILD)/efi/boot
#	cp vmlinuz $(BUILD)/images

#$(OBJS): $(SRCS)
#	$(CC) -c $< $(INC) $(CFLAGS) -o $@

#.PHONY: bootiso
#bootiso: $(OUT)
#	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	

always:
	mkdir -p $(BUILD)/efi/boot
	mkdir -p $(BUILD)/images

clean:
	rm -rf $(BUILD)
	rm -f *.o *.so
	rm $(OUT)

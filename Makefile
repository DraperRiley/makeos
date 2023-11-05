BOOTDIR=src/boot/
KERNDIR=src/kernel
BUILDDIR=dist

LEGACY_BOOT_DIR=src/boot/legacy

BOOTFILE=boot.asm
BOOTOUT=boot.bin

# Floppy
FLOPPYIMG =main_floppy.img
FAT12HEADERS=src/boot/headers/fat12/fat12headers.asm
HEADER_FILE=headers.asm

qemu-x86_64-floppy: floppy_img
	qemu-system-x86_64 \
	-drive \
	format=raw,\
	file=$(BUILDDIR)/$(FLOPPYIMG),\
	if=floppy,\
	media=disk

floppy_img: $(BUILDDIR)/$(FLOPPYIMG)

$(BUILDDIR)/$(FLOPPYIMG): boot.bin
	dd if=/dev/zero of=$(BUILDDIR)/$(FLOPPYIMG) bs=512 count=2880
	mkfs.fat -F 12 -n "NBOS" $(BUILDDIR)/$(FLOPPYIMG)
	dd if=$(BUILDDIR)/$(BOOTOUT) of=$(BUILDDIR)/$(FLOPPYIMG) conv=notrunc
	mcopy -i $(BUILDDIR)/$(FLOPPYIMG) $(BUILDDIR)/$(BOOTOUT) "::$(BOOTOUT)"

boot.bin: always headers
	nasm -i $(BUILDDIR) -fbin $(LEGACY_BOOT_DIR)/$(BOOTFILE) -o $(BUILDDIR)/$(BOOTOUT)

headers:
	cp $(FAT12HEADERS) $(BUILDDIR)/$(HEADER_FILE)

always:
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

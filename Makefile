SRC_DIR := src
BOOT_DIR := $(SRC_DIR)/boot
KERN_DIR := $(SRC_DIR)/kernel
BUILD_DIR := build

LEGACY_BOOT_DIR := $(BOOT_DIR)/legacy

BOOTFILE := boot.asm
BOOTOUT := boot.bin

# Floppy
FLOPPYIMG := main_floppy.img
FAT12HEADERS := src/boot/headers/fat12/fat12headers.asm
HEADER_FILE := headers.asm

qemu-x86_64-floppy : $(FLOPPYIMG)
	qemu-system-x86_64 \
	-drive \
	format=raw,\
	file=$(BUILD_DIR)/$(FLOPPYIMG),\
	if=floppy,\
	media=disk

qemu-i386-floppy-debug : clean $(FLOPPYIMG)
	qemu-system-i386 \
	-S \
	-gdb tcp::9000 \
	-drive \
	format=raw,\
	file=$(BUILD_DIR)/$(FLOPPYIMG),\
	if=floppy,\
	media=disk

qemu-i386-floppy-nodebug : clean $(FLOPPYIMG)
	qemu-system-i386 \
	-drive \
	format=raw,\
	file=$(BUILD_DIR)/$(FLOPPYIMG),\
	if=floppy,\
	media=disk

$(FLOPPYIMG) : $(BUILD_DIR)/$(FLOPPYIMG)

$(BUILD_DIR)/$(FLOPPYIMG) : $(BOOTOUT)
	dd if=/dev/zero of=$(BUILD_DIR)/$(FLOPPYIMG) bs=512 count=2880
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/$(FLOPPYIMG)
	dd if=$(BUILD_DIR)/$(BOOTOUT) of=$(BUILD_DIR)/$(FLOPPYIMG) conv=notrunc
	mcopy -i $(BUILD_DIR)/$(FLOPPYIMG) $(BUILD_DIR)/$(BOOTOUT) "::$(BOOTOUT)"

bootbin: $(BOOTOUT)
$(BOOTOUT) : always headers
	nasm -i $(BUILD_DIR) -I$(LEGACY_BOOT_DIR) -fbin $(LEGACY_BOOT_DIR)/$(BOOTFILE) -o $(BUILD_DIR)/$(BOOTOUT)

.PHONY: headers
headers:
	cp $(FAT12HEADERS) $(BUILD_DIR)/$(HEADER_FILE)

.PHONY: always
always:
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

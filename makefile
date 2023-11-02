BOOTDIR="src/boot"
KERNDIR="src/kernel"
BUILDDIR="dist"

BOOTFILE = "boot.asm"
BOOTOUT  = "boot.bin"

qemu-x86_64-floppy: boot.bin
	qemu-system-x86_64 \
	-drive \
	format=raw,\
	file=$(BUILDDIR)/$(BOOTOUT),\
	if=floppy,\
	media=disk

boot.bin: always
	nasm -fbin $(BOOTDIR)/$(BOOTFILE) -o $(BUILDDIR)/$(BOOTOUT)

always:
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

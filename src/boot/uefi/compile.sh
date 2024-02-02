x86_64-linux-gnu-gcc hello.c                             \
      -c                                 \
      -fno-stack-protector               \
      -fpic                              \
      -fshort-wchar                      \
      -mno-red-zone                      \
      -ffreestanding			\
      -nostdlib		\
      -I $HOME/gnu-efi/inc        \
      -I $HOME/gnu-efi/inc/x86_64 \
      -DEFI_FUNCTION_WRAPPER             \
      -e efi_main	\
      -o main.o
 
ld main.o                         \
     $HOME/gnu-efi/x86_64/gnuefi/crt0-efi-x86_64.o     \
     -nostdlib                      \
     -znocombreloc                  \
     -T $HOME/gnu-efi/gnuefi/elf_x86_64_efi.lds \
     -shared                        \
     -Bsymbolic                     \
     -L $HOME/gnu-efi/x86_64/gnuefi/               \
     -L $HOME/gnu-efi/x86_64/lib/ \
     -l:libgnuefi.a                 \
     -l:libefi.a                   \
     -o main.so
 
objcopy -j .text                \
          -j .sdata               \
          -j .data                \
          -j .dynamic             \
          -j .dynsym              \
          -j .rel                 \
          -j .rela                \
          -j .reloc               \
          --target=efi-app-x86_64 \
          main.so                 \
          BOOTX64.EFI

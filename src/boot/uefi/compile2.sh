gcc hello.c                             \
      -c                                 \
      -g -O2 -Wall \
      -Wextra -Werror \
      -Wno-pointer-sign \
      -funsigned-char -fshort-wchar \
      -fno-stack-check \
      -fno-merge-all-constants \
      -fno-strict-aliasing \
      -ffreestanding \
      -fno-stack-protector               \
      -fPIC                              \
      -mno-red-zone                      \
      -I $HOME/gnu-efi/inc        \
      -I $HOME/gnu-efi/inc/x86_64 \
      -DEFI_FUNCTION_WRAPPER             \
      -o main.o
 
ld main.o                         \
     /usr/local/lib/crt0-efi-x86_64.o     \
     -nostdlib                      \
     -znocombreloc                  \
     -T /usr/local/lib/elf_x86_64_efi.lds \
     -shared                        \
     -Bsymbolic                     \
     -L /usr/local/lib			\
     -lgnuefi               \
     -lefi                    \
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
          main.efi

cmake_minimum_required(VERSION 3.16)
project(MakeOS VERSION 1.0
	DESCRIPTION "Custom kernel"
	LANGUAGES C ASM
)

set(CMAKE_C_COMPILER "$ENV{HOME}/makeos/toolchain/x86_64-elf/bin/x86_64-elf-gcc")
set(CMAKE_ASM_COMPILER "$ENV{HOME}/makeos/toolchain/x86_64-elf/bin/x86_64-elf-as")
set(CMAKE_C_COMPILER_LINKER "$ENV{HOME}/makeos/toolchain/x86_64-elf/bin/x86_64-elf-ld")

#set(CMAKE_C_COMPILER "$ENV{HOME}/makeos/toolchain/i686-elf/bin/i686-elf-gcc")
#set(CMAKE_ASM_COMPILER "$ENV{HOME}/makeos/toolchain/i686-elf/bin/i686-elf-as")
#set(CMAKE_C_COMPILER_LINKER "$ENV{HOME}/makeos/toolchain/i686-elf/bin/i686-elf-ld")

# Multiboot
add_library(multiboot STATIC 
	multiboot/boot.S
	multiboot/print.S
	multiboot/paging.S
	multiboot/lgdt.S
)
target_include_directories(multiboot PUBLIC include)

# Main
add_executable(MakeOS
		kern/main.c
)

target_link_libraries(MakeOS PUBLIC multiboot)
target_compile_options(MakeOS
	PUBLIC -std=gnu99 
	PUBLIC -ffreestanding
	PUBLIC -nostdlib 
	PUBLIC -O2 
	PUBLIC -Wall 
	PUBLIC -Wextra
)
target_link_options(MakeOS
	PUBLIC -T linker.ld
	PUBLIC -ffreestanding 
	PUBLIC -O2 
	PUBLIC -nostdlib
	PUBLIC -lgcc
)

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

add_library(std STATIC
	lib/stdlib.c
	lib/stdio.c
)

target_compile_options(std PRIVATE
	PRIVATE -std=gnu99
	PRIVATE -ffreestanding
	PRIVATE -nostdlib
)

target_include_directories(std PUBLIC include)

# Main
add_executable(MakeOS
		kern/main.c
		kern/idt.c
		kern/idt.S
)

target_link_libraries(MakeOS PUBLIC multiboot std)
target_compile_options(MakeOS
	PUBLIC $<$<COMPILE_LANGUAGE:C>:
		-std=gnu99 
		-ffreestanding
		-nostdlib
		-O2
		-Wall
		-Wextra
		-mcmodel=large
	>
	PUBLIC $<$<COMPILE_LANGUAGE:ASM>:
		-am
	>
)

target_link_options(MakeOS
	PUBLIC -T linkerhh.ld
	PUBLIC -ffreestanding 
	PUBLIC -O2 
	PUBLIC -nostdlib
	PUBLIC -lgcc
)

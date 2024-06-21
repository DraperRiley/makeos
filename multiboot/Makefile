AS := x86_64-elf-as
SRCS := $(wildcard *.S)
OBJS := $(SRCS:.S=.o)

all: $(OBJS)

%.o: %.S
	$(AS) $< -o $@

.PHONY: clean
clean:
	rm *.o

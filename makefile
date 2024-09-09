UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	FORMAT = elf64
	LINKER = ld
endif
ifeq ($(UNAME_S),Darwin)
	FORMAT = macho64
	LINKER = gcc
endif

all: Calculadora

Calculadora: Calculadora.asm
	nasm -f $(FORMAT) Calculadora.asm
	$(LINKER) -o Calculadora Calculadora.o

clean:
	rm -f Calculadora Calculadora.o
	rm -f *~
	rm -f *.o

rebuild:
	make clean
	make all

run: Calculadora

	./Calculadora

# End of the makefile 
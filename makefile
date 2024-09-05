all: Calculadora.asm

Calculadora.asm: Calculadora.o
	ld -m elf_i386 -o Calculadora Calculadora.o

Calculadora.o: Calculadora.asm
	nasm -f elf -g -F stabs Calculadora.asm

clean:
	rm -f Calculadora Calculadora.o

run: Calculadora

	./Calculadora

# End of the makefile 
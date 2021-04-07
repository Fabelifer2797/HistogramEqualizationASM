all: build run


build:
	nasm -f elf HistogramEqualization.asm
	ld -m elf_i386 HistogramEqualization.o -o HistogramEqualization
run:
	./HistogramEqualization
	
	
	

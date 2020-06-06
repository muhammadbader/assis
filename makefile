all: exec

exec: ass3.o
	gcc -m32 -Wall -g ass3 ass3.o

Ass3.o: ass3.s
	nasm -f elf ass3.s -o ass3.o

.PHONY: clean
clean:
	rm -rf *.o ass3

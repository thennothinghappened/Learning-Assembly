
hello_world:
	nasm -f macho64 hello_world.asm
	gcc -arch x86_64 -lSystem -fno-pie -o ./hello_world.bin ./hello_world.o
	echo ""
	./hello_world.bin

clean:
	rm ./*.o
	rm ./*.bin

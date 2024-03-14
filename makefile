
guess_the_string:
	nasm -f macho64 ./guess_the_string.asm
	gcc -arch x86_64 -lSystem -o ./guess_the_string.bin ./guess_the_string.o
	echo ""
	
	./guess_the_string.bin

clean:
	rm ./*.o
	rm ./*.bin

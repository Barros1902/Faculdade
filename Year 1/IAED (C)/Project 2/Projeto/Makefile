run: proj2
	./proj2

build: proj2

proj2: *.c
	clear
	gcc -O3 -ansi -Wall -Wextra -Werror *.c -o proj2

debug: *.c
	gcc -O3 -ansi -Wall -Wextra -Werror -g *.c -o proj2D
	valgrind ./proj2D
	rm proj2D
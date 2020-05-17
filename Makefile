TARGET = res.out

.PHONY: all clear

all: $(TARGET)

$(TARGET):
	gcc -I libgit2/include/ main.c -c
	gcc -I libgit2/include/ commit.c -c
	gcc -L libgit2/build -Wl,-rpath=libgit2/build -Wall -o $(TARGET) main.o commit.o -lgit2

clear:
	rm -rf $(TARGET) *.o

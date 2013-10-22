PROGRAM = chikatetsu
COMPILER = dmd
FLAGS =

all:
	$(COMPILER) *.d */*.d $(FLAGS) -of$(PROGRAM)

run: all
	./chikatetsu

clean:
	rm -f *.o

PROGRAM = chikatetsu
COMPILER = dmd
FLAGS =

all:
	$(COMPILER) *.d */*.d $(FLAGS) -of$(PROGRAM)

clean:
	rm -f *.o

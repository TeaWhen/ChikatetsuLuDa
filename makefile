PROGRAM = chikatetsu
DCC = dmd
DFLAGS = -m32 -O $(shell pwd)/orange/lib/32/liborange.a -I$(shell pwd)/orange
SRCDIRS = . API CFI CLI
SRCS = $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.d))
OBJS = $(SRCS:.d=.o)

all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(DCC) $(DFLAGS) -of$@ $(OBJS)

%.o: %.d
	$(DCC) $(DFLAGS) -c $< -of$*.o

run: all
	./$(PROGRAM)

rebuild: clean all

clean:
	rm -f *.o */*.o data/* $(PROGRAM)

# debug use only
show:
	@echo 'PROGRAM   :' $(PROGRAM)
	@echo 'DCC       :' $(DCC)
	@echo 'DFLAGS    :' $(DFLAGS)
	@echo 'SRCDIRS   :' $(SRCDIRS)
	@echo 'SRCS      :' $(SRCS)
	@echo 'OBJS      :' $(OBJS)

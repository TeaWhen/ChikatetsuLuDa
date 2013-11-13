PROGRAM = chikatetsu
DCC = dmd
DFLAGS = -w -O
SRCDIRS = . API CFI CLI
SRCS = $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.d))
OBJS = $(SRCS:.d=.o)

all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(DCC) $(DFLAGS) -of$@ $(OBJS)

%.o: %.d
	$(DCC) $(DFLAGS) -c $< -of$*.o

rebuild: clean all

clean:
	rm -f *.o */*.o $(PROGRAM)

# debug use only
show:
	@echo 'PROGRAM   :' $(PROGRAM)
	@echo 'DCC       :' $(DCC)
	@echo 'DFLAGS    :' $(DFLAGS)
	@echo 'SRCDIRS   :' $(SRCDIRS)
	@echo 'SRCS      :' $(SRCS)
	@echo 'OBJS      :' $(OBJS)

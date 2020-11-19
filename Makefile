LINKER	     = g++
CC	     = g++
LDFLAGS	     = 
LDFLAGS	     = 
COPTS	     = -O2 -std=c++17 -Wall --pedantic-errors
INCLUDE	     =

OBJS          = inverse_product_test.o\

PROGRAM	      = a.out

all:		$(PROGRAM)

$(PROGRAM): $(OBJS)
		$(LINKER) $(COPTS) $(OBJS) -o $(PROGRAM) $(LDFLAGS)

clean:
		rm -f $(PROGRAM) *.o *~ ;\

.SUFFIXES: .o .cc

.cc.o :
		$(CC) $(COPTS) $(INCLUDE) -c -o $*.o $*.cc

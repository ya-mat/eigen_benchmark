LINKER	     = g++
CC	     = g++
LDFLAGS	     =
COPTS	     = -O3 -std=c++17 -Wall --pedantic-errors
INCLUDE	     =

FLINKER	     = gfortran
FC	     = gfortran
FLDFLAGS	     = -llapack -lrefblas
FOPTS	     = -cpp -O3 -ffree-line-length-none -fmax-errors=3
FINCLUDE	     =

OBJS          = main.o\

FOBJS          = fmain.o\

PROGRAM	      = a.out
FPROGRAM	= f.out

all:		$(PROGRAM) $(FPROGRAM)

$(PROGRAM): $(OBJS)
		$(LINKER) $(COPTS) $(OBJS) -o $(PROGRAM) $(LDFLAGS)

$(FPROGRAM): $(FOBJS)
		$(FLINKER) $(FOPTS) $(FOBJS) -o $(FPROGRAM) $(FLDFLAGS)

clean:
		rm -f $(PROGRAM) $(FPROGRAM) *.o *~ ;\

.SUFFIXES: .o .cc .f90

.cc.o :
		$(CC) $(COPTS) $(INCLUDE) -c -o $*.o $*.cc

.f90.o :
		$(FC) $(FOPTS) $(FINCLUDE) -c -o $*.o $*.f90

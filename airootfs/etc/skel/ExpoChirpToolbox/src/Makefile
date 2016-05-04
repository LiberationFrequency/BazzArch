NAME=expochirp~
CSYM= expochirp_tilde
BINDEST=../tools

# for Windows, set path to Pd executable here:
PDPATH = "c:/pd_local"

current: pd_darwin


# ----------------------- WIN i386 with MinGW-----------------------

pd_win: $(NAME).dll

.SUFFIXES: .dll


WINCFLAGS = -DPD -DNT -W3 -WX -Werror -Wno-unused -mms-bitfields\
	-Wno-parentheses -Wno-switch -O6 -funroll-loops -fomit-frame-pointer\
	-fno-strict-aliasing

LDFLAGS = --export-dynamic -shared	

WININCLUDE =  -I./


.c.dll:
	gcc $(WINCFLAGS) $(WININCLUDE) -c $*.c
	gcc $(LDFLAGS) -o $*.dll $*.o $(PDPATH)/pd.dll 	
	strip --strip-unneeded $*.dll
	rm -f $*.o ../$*.dll
	rm -f $*.o $(BINDEST)/$*.dll
	cp $*.dll $(BINDEST)/$*.dll


# ----------------------- LINUX i386 -----------------------

pd_linux: $(NAME).pd_linux

.SUFFIXES: .pd_linux

LINUXCFLAGS = -DPD -DUNIX -DICECAST -O2 -funroll-loops -fomit-frame-pointer \
    -Wall -W -Wshadow -Wstrict-prototypes -Werror -fno-strict-aliasing \
    -Wno-unused -Wno-parentheses -Wno-switch

LINUXINCLUDE =  -I./

.c.pd_linux:
	cc $(LINUXCFLAGS) $(LINUXINCLUDE) -o $*.o -c $*.c
	ld --export-dynamic  -shared -o $*.pd_linux $*.o -lc -lm
	strip --strip-unneeded $*.pd_linux
	rm -f $*.o $(BINDEST)/$*.pd_linux
	cp $*.pd_linux $(BINDEST)/$*.pd_linux

# ----------------------- Mac OSX -----------------------

pd_darwin: $(NAME).pd_darwin

.SUFFIXES: .pd_darwin

DARWINCFLAGS = -DPD -O3 -Wall -W -Wshadow -Wstrict-prototypes \
    -Wno-unused -Wno-parentheses -Wno-switch

DARWININCLUDE = -I./

DARWINARCH = -arch ppc7400 -arch i386 -arch x86_64

.c.pd_darwin:
	cc $(DARWINCFLAGS) $(DARWININCLUDE) $(DARWINARCH) -o $*.o -c $*.c
	cc -bundle -undefined suppress  -flat_namespace $(DARWINARCH) -o $*.pd_darwin $*.o 
	rm -f $*.o $(BINDEST)/$*.pd_darwin
	cp $*.pd_darwin $(BINDEST)/$*.pd_darwin
	rm -f $*.pd_darwin

# ----------------------------------------------------------


	

clean:
	rm -f *.o *.pd_* so_locations

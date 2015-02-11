PERL   ?= $(CURDIR)/../brew/perl-5.10.1
ARCHLIB = $(shell $(PERL) -MConfig -e 'print $$Config{archlib}')
LIBS    = $(shell $(PERL) -MConfig -e 'print $$Config{libs}')
CFLAGS  = -fPIC -Wall -O2 -I$(ARCHLIB)/CORE
LDFLAGS = $(LIBS)
LIBPERL = $(ARCHLIB)/CORE/libperl.a

# using HePV() emits a strict-aliasing warning
hv.o: CFLAGS += -Wno-strict-aliasing

libhv.so :: hv.map
libhv.so :: hv.o $(LIBPERL)
	cc -shared -o $@ -Wl,--version-script=hv.map $^ $(LDFLAGS)

clean :
	-rm try *.o *.so *.a

distclean : clean
	-rm -rf $(PERLBREW_ROOT)

.PHONY: target clean distclean brew

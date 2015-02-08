PERLVER = perl-5.10.1
export PERLBREW_ROOT = $(CURDIR)/root

target: brew libhv.so
brew: $(PERLBREW_ROOT)/perls/$(PERLVER)

#### Rules to bootstrap perlbrew
PERL = env PERLBREW_ROOT=$(PERLBREW_ROOT) \
       perlbrew --quiet exec --with $(PERLVER) perl

$(PERLBREW_ROOT): export PERLBREW_HOME = $(CURDIR)/home
$(PERLBREW_ROOT):
	perlbrew init

$(PERLBREW_ROOT)/perls/$(PERLVER): export PERLBREW_CONFIGURE_FLAGS = -de -A ccflags=-fPIC
$(PERLBREW_ROOT)/perls/$(PERLVER): $(PERLBREW_ROOT)
	perlbrew --notest install $(PERLVER)

#### Rules to build the envelope .so around around libperl.a

ARCHLIB = $(shell $(PERL) -MConfig -e 'print $$Config{archlib}')
LIBS    = $(shell $(PERL) -MConfig -e 'print $$Config{libs}')
CFLAGS  = -fPIC -Wall -O2 -I$(ARCHLIB)/CORE
LDFLAGS = $(LIBS)
LIBPERL = $(ARCHLIB)/CORE/libperl.a

$(LIBPERL): $(PERLBREW_ROOT)/perls/$(PERLVER)

# using HePV() emits a strict-aliasing warning
hv.o: CFLAGS += -Wno-strict-aliasing

libhv.so :: hv.version
libhv.so :: hv.o $(LIBPERL)
	cc -shared -o $@ -Wl,--version-script=hv.version $^ $(LDFLAGS)

libhv.o :: $(LIBPERL)
libhv.o :: hv.o
	$(LD) --relocatable -o $@ $^ --exclude-libs ALL -L$(ARCHLIB)/CORE -lperl

try: try.o libhv.o
	cc -o try try.o libhv.o $(LDFLAGS)
	#cc -o $@ $< -L. -lhv

clean:
	-rm try *.o *.so *.a

distclean: clean
	-rm -r $(PERLBREW_ROOT)

.PHONY: target clean distclean brew

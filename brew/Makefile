TARGET ?= perl-5.10.1
export PERLBREW_ROOT = $(CURDIR)/root
export PERLBREW_HOME = $(CURDIR)/home
export PERLBREW_CONFIGURE_FLAGS = -de -A ccflags=-fPIC

target : $(TARGET)

$(PERLBREW_ROOT) :
	perlbrew init

$(PERLBREW_ROOT)/perls/$(TARGET) : $(PERLBREW_ROOT)
	perlbrew --notest install $(TARGET)

$(TARGET) : $(PERLBREW_ROOT)/perls/$(TARGET)
	echo '#!/bin/bash' > $@
	echo 'export PERLBREW_HOME=$(CURDIR)/home' >> $@
	echo 'export PERLBREW_ROOT=$(CURDIR)/root' >> $@
	echo 'source $(PERLBREW_ROOT)/etc/bashrc' >> $@
	echo 'exec perlbrew --quiet exec --with $(TARGET) perl "$$@"' >> $@
	chmod +x $@

clean :
	rm -rf perl-* $(PERLBREW_ROOT) $(PERLBREW_HOME)

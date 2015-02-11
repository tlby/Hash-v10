use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Hash::v10',
    VERSION_FROM      => 'lib/Hash/v10.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Hash/v10.pm', # retrieve abstract from module
       AUTHOR         => 'Robert Stone <talby@trap.mtview.ca.us>') : ()),
    BUILD_REQUIRES    => {
        'App::perlbrew' => '0.66',
    },
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    # Un-comment this if you add C files to link with later:
    #OBJECT            => '$(O_FILES)', # link all the C files too
    macro             => { LIBHV => 'libhv.so' },
    dynamic_lib       => {
        INST_DYNAMIC_DEP => '$(INST_ARCHAUTODIR)/libhv.$(DLEXT)',
        OTHERLDFLAGS => q{-L$(INST_ARCHAUTODIR) -Wl,-rpath='$${ORIGIN}' -lhv},
    },
);
if  (eval {require ExtUtils::Constant; 1}) {
  # If you edit these definitions to change the constants used by this module,
  # you will need to use the generated const-c.inc and const-xs.inc
  # files to replace their "fallback" counterparts before distributing your
  # changes.
  my @names = (qw());
  ExtUtils::Constant::WriteConstants(
                                     NAME         => 'Hash::v10',
                                     NAMES        => \@names,
                                     DEFAULT_TYPE => 'IV',
                                     C_FILE       => 'const-c.inc',
                                     XS_FILE      => 'const-xs.inc',
                                  );

}
else {
  use File::Copy;
  use File::Spec;
  foreach my $file ('const-c.inc', 'const-xs.inc') {
    my $fallback = File::Spec->catfile('fallback', $file);
    copy ($fallback, $file) or die "Can't copy $fallback to $file: $!";
  }
}

sub MY::postamble { q{
src/$(LIBHV):
	$(MAKE) -C brew perl-5.10.1
	$(MAKE) -C src PERL=$(CURDIR)/brew/perl-5.10.1 $(LIBHV)

$(INST_DYNAMIC_DEP): src/$(LIBHV)
	install -m 755 $< $@

clean ::
	$(MAKE) -C src clean

realclean ::
	$(MAKE) -C brew clean

.PHONY : src/$(LIBHV)
} }

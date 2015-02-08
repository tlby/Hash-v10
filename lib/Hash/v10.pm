package Hash::v10;

use 5.010001;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Hash::v10 ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Hash::v10::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Hash::v10', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

Hash::v10 - Perl extension for perl v5.10 compatible hashes

=head1 SYNOPSIS

  use Hash::v10;
  tie my(%legacy), 'Hash::v10';

=head1 DESCRIPTION

This provides a perl v5.10 compatible hash.  It is intended as a last
resort for porting stubborn code across the "Hash randomization" feature
in perl v5.18 and above.  It achieves this by embedding a perl v5.10
interpeters HV implementation, and allowing you to tie() specific hashes
back to having earlier hash semantics.

The source code for this project may also serve as a starting point for
other reverse compatibility solutions via interpreter embedding.

=head2 EXPORT

None.



=head1 AUTHOR

Robert Stone, E<lt>talby@trap.mtview.ca.usE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by Robert Stone

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut

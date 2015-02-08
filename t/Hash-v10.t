# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Hash-v10.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 16;
use Scalar::Util ();
use Devel::Peek ();
BEGIN { use_ok('Hash::v10') };

#########################

sub simple {
    tie my(%it), 'Hash::v10';
    ok(tied(%it), 'tiehash');
    $it{$_} = 100 + $_ for 1 .. 10;
    is($it{'nope'}, undef, 'fetch() => undef');
    is($it{6}, 106, 'fetch() => value');
    is(exists $it{'nope'}, '', 'exists() => undef');
    is(exists $it{8}, '1', 'exists() => value');
    is('' . %it, '9/16', 'scalar()');
    is_deeply(
        [ %it ],
        [qw(6 106 3 103 7 107 9 109 2 102 8 108 1 101 4 104 10 110 5 105)],
        'iterate',
    );
    is_deeply(
	[ keys %it ],
        [qw(6 3 7 9 2 8 1 4 10 5)],
        'keys()',
    );
    is_deeply(
	[ values %it ],
        [qw(106 103 107 109 102 108 101 104 110 105)],
        'values()',
    );
    {
        my $ref = [];
        $it{ref} = $ref;
        Scalar::Util::weaken($ref);
        isa_ok($ref, 'ARRAY', 'reference held before overwrite');
        $it{ref} = 12;
        is($ref, undef, 'reference released after overwrite');
    }
    {
        my $ref = [];
        $it{ref} = $ref;
        Scalar::Util::weaken($ref);
        isa_ok($ref, 'ARRAY', 'reference held before delete');
        delete $it{ref};
        is($ref, undef, 'reference released after delete');
    }
    {
        my $ref = [];
        $it{ref} = $ref;
        Scalar::Util::weaken($ref);
        isa_ok($ref, 'ARRAY', 'reference held before clear');
        %it = ();
        is($ref, undef, 'reference released after clear');
    }
}

simple();

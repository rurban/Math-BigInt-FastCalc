#!perl

BEGIN {
    unless ($ENV{AUTHOR_TESTING}) {
        require Test::More;
        Test::More::plan(skip_all =>
                         'these tests are for testing by the author');
    }
}

use strict;
use warnings;

use Test::More tests => 4957;

###############################################################################
# Read and load configuration file and backend library.

use Config::Tiny ();

my $config_file = 't/author-lib.ini';
my $config = Config::Tiny -> read('t/author-lib.ini')
  or die Config::Tiny -> errstr();

# Read the library to test.

our $LIB = $config->{_}->{lib};

die "No library defined in file '$config_file'"
  unless defined $LIB;
die "Invalid library name '$LIB' in file '$config_file'"
  unless $LIB =~ /^[A-Za-z]\w*(::\w+)*\z/;

# Load the library.

eval "require $LIB";
die $@ if $@;

###############################################################################

can_ok($LIB, '_len');

use lib 't';
use Math::BigInt::Lib::TestUtil qw< randstr >;

# Generate test data.

my @data;

for (my $x = 0 ; $x <= 250 ; ++ $x) {
    $x = sprintf "%u", $x;
    push @data, [ $x, length($x) ];
}

for (my $n = 4 ; $n <= 250 ; ++ $n) {
    for (1 .. 4) {
        my $x = randstr($n, 10);
        push @data, [ $x, $n ];
    }
}

# List context.

for (my $i = 0 ; $i <= $#data ; ++ $i) {
    my ($in0, $out0) = @{ $data[$i] };

    my ($x, @got);

    my $test = qq|\$x = $LIB->_new("$in0"); |
             . qq|\@got = $LIB->_len(\$x);|;

    eval $test;
    is($@, "", "'$test' gives emtpy \$\@");

    subtest "_len() in list context: $test", sub {
        plan tests => 3,

        cmp_ok(scalar @got, '==', 1,
               "'$test' gives one output arg");

        is(ref($got[0]), "",
           "'$test' output arg is a Perl scalar");

        is($got[0], $out0,
           "'$test' output arg has the right value");
    };
}

# Scalar context.

for (my $i = 0 ; $i <= $#data ; ++ $i) {
    my ($in0, $out0) = @{ $data[$i] };

    my ($x, $got);

    my $test = qq|\$x = $LIB->_new("$in0"); |
             . qq|\$got = $LIB->_len(\$x);|;

    eval $test;
    is($@, "", "'$test' gives emtpy \$\@");

    subtest "_len() in scalar context: $test", sub {
        plan tests => 2,

        is(ref($got), "",
           "'$test' output arg is a Perl scalar");

        is($got, $out0,
           "'$test' output arg has the right value");
    };
}

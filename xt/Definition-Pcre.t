#!/usr/bin/perl

use 5.012;
use warnings;

use Test::More;
use Test::Enbld::Definition;

SKIP: {
          skip "Skip build pcre test because none of test env.",
               1 unless ( $ENV{PERL_ENBLD_TEST_DEFINITION} );
           
           build_ok( 'pcre', undef, undef, 'first test' );

       };

done_testing();

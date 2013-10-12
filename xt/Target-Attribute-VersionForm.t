#!/usr/bin/perl

use 5.012;
use warnings;

use Test::More;

require Enbld::Target::AttributeCollector;

my $no = Enbld::Target::AttributeCollector->new;
eval { $no->add( 'VersionForm' ) };
like( $@, qr/ABORT:Attribute 'VersionForm' isn't defined/, 'no parameter' );

my $empty = Enbld::Target::AttributeCollector->new;
eval { $empty->add( 'VersionForm', '' ) };
like( $@, qr/ABORT:Attribute 'VersionForm' isn't defined/, 'null parameter' );

my $fixed = Enbld::Target::AttributeCollector->new;
$fixed->add( 'VersionForm', '5\.\d{1,2}\.\d' );
is( $fixed->VersionForm, '5\.\d{1,2}\.\d', 'fixed parameter' );

my $coderef = Enbld::Target::AttributeCollector->new;
$coderef->add( 'VersionForm', sub { return '5\.\d{1,2}\.\d' } );
is( $coderef->VersionForm, '5\.\d{1,2}\.\d', 'coderef parameter' );

my $invalid = Enbld::Target::AttributeCollector->new;
$invalid->add( 'VersionForm', '\d{\1,\2}' );
eval { $invalid->VersionForm };
like( $@,
        qr/ABORT:Attribute 'VersionForm' is NOT valid regular expression string/
        , 'invalid version form string' );

my $undef = Enbld::Target::AttributeCollector->new;
$undef->add( 'VersionForm', sub { return } );
eval { $undef->VersionForm };
like( $@, qr/ABORT:Attribute 'VersionForm' is empty string/, 'return undef' );

my $array = Enbld::Target::AttributeCollector->new;
$array->add( 'VersionForm', sub { return [ '5\.\d{1,2}\.\d' ] } );
eval { $array->VersionForm };
like( $@, qr/ABORT:Attribute 'VersionForm' isn't scalar value/,
                'return array reference' );

done_testing();

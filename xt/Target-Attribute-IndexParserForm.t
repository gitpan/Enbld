#!/usr/bin/perl

use 5.012;
use warnings;

use Test::More;

require Enbld::Target::AttributeCollector;

my $parser = '<a href="archive-\d\.\d{2}\.tar\.gz">';

my $no = Enbld::Target::AttributeCollector->new;
$no->add( 'ArchiveName', 'archive' );
$no->add( 'VersionForm', '\d\.\d{2}' );
$no->add( 'Extension', 'tar.gz' );
$no->add( 'IndexParserForm' );
is( $no->IndexParserForm, $parser, 'no parameter' );

my $empty = Enbld::Target::AttributeCollector->new;
eval { $empty->add( 'IndexParserForm', '' ) };
like( $@, qr/ABORT:Attribute 'IndexParserForm' isn't defined/,
                'empty string parameter' );

my $fixed = Enbld::Target::AttributeCollector->new;
$fixed->add( 'IndexParserForm', $parser );
is( $fixed->IndexParserForm, $parser, 'fixed parameter' );

my $coderef = Enbld::Target::AttributeCollector->new;
$coderef->add( 'IndexParserForm', sub { return $parser } );
is( $coderef->IndexParserForm, $parser, 'coderef parameter' );

my $invalid = Enbld::Target::AttributeCollector->new;
$invalid->add( 'IndexParserForm', '\d{\1,\2}' );
eval { $invalid->IndexParserForm };
like( $@, qr/NOT valid regular expression string/,
        'index parser form is invalid string' );

my $undef = Enbld::Target::AttributeCollector->new;
$undef->add( 'IndexParserForm', sub { return } );
eval { $undef->IndexParserForm };
like( $@, qr/ABORT:Attribute 'IndexParserForm' is empty string/,
        'return undef' );

my $array = Enbld::Target::AttributeCollector->new;
$array->add( 'IndexParserForm', sub { return [ $parser ] } );
eval { $array->IndexParserForm };
like( $@, qr/ABORT:Attribute 'IndexParserForm' isn't scalar value/,
                'return array reference' );

done_testing();

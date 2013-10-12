package Enbld::Definition::Python;

use 5.012;
use warnings;

use parent qw/Enbld::Definition/;

sub initialize {
    my $self = shift;

    $self->SUPER::initialize;

    $self->{defined}{ArchiveName}       =   'Python';
    $self->{defined}{WebSite}           =   'http://www.python.org';
    $self->{defined}{VersionForm}       =   '\d\.\d(\.\d)?';
    $self->{defined}{Extension}         =   'tgz';
    $self->{defined}{DownloadSite}      =   'http://www.python.org/ftp/python/';

    $self->{defined}{VersionList}       =   \&set_versionlist;
    $self->{defined}{URL}               =   \&set_url;

    $self->{defined}{CommandConfigure}  =   './configure';
    $self->{defined}{CommandMake}       =   'make';
    $self->{defined}{CommandTest}       =   'make test';
    $self->{defined}{CommandInstall}    =   'make install';

    return $self;
}

sub set_versionlist {
    my $attributes = shift;

    require Enbld::HTTP;
    my $first_html = Enbld::HTTP->new( $attributes->IndexSite )->get_html;

    my $first_list = $first_html->parse_version(
            quotemeta( '<a href="') . '\d\.\d(\.\d)?' . quotemeta( '/">' ),
            '\d\.\d(\.\d)?'
            );

    my $versionlist;
    for my $ver_num ( @{ $first_list } ) {
        my $url = $attributes->IndexSite . $ver_num;
        my $html = Enbld::HTTP->new( $url )->get_html;

        my $list = $html->parse_version(
            quotemeta( '<a href="Python-' ) .
            '\d\.\d(\.\d)?' . quotemeta( '.tgz' ) . quotemeta( '">' ) .
            quotemeta( 'Python-' ) .
            '\d\.\d(\.\d)?' . quotemeta( '.tgz</a>' ),
            '\d\.\d(\.\d)?'
            );

        if ( $list ) {
            push @{ $versionlist }, $ver_num;
        }

    }

    return $versionlist;
}

sub set_url {
    my $attributes = shift;

    my $ver = $attributes->Version;

    my $filename = $attributes->Filename;
    my $url = $attributes->DownloadSite . $ver . '/' . $filename;

    return $url;
}

1;

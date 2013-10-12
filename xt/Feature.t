#!/usr/bin/perl

use 5.012;
use warnings;

use Test::More;

use File::Temp;

require_ok( 'Enbld::Feature' );

subtest 'no deploy' => sub {

    Enbld::Feature->initialize(
            force       => 1,
            make_test   => 1,
            current     => 1,
            );

    is( Enbld::Feature->is_force_install, 1, 'force' );
    is( Enbld::Feature->is_make_test_all, 1, 'make test' );
    is( Enbld::Feature->is_current_mode,  1, 'current' );

    Enbld::Feature->reset;

    done_testing();
};

subtest 'set deploy mode' => sub {

    Enbld::Feature->initialize;

    my $dir = File::Temp->newdir;
    Enbld::Feature->set_deploy_mode( $dir );

    ok( Enbld::Feature->is_deploy_mode, 'is deploy mode' );
    is( Enbld::Feature->deploy_path, $dir, 'deploy path' );

    Enbld::Feature->reset;

    done_testing();
};

subtest 'set invalid deploy path' => sub {

    Enbld::Feature->initialize;

    my $dir = 'invalid/';
    eval { Enbld::Feature->set_deploy_mode( $dir ) };
    like( $@, qr/ERROR:'$dir' is nonexistent/, 'set invalid deploy path' );

    Enbld::Feature->reset;

    done_testing();

};

subtest 'set deploy path at initialization' => sub {

    my $dir = File::Temp->newdir;
    Enbld::Feature->initialize( deploy => $dir );

    ok( Enbld::Feature->is_deploy_mode, 'is deploy mode' );
    is( Enbld::Feature->deploy_path, $dir, 'deploy path' );

    Enbld::Feature->reset;

    done_testing();

};

SKIP: {
          skip "skip ... in root user", 1 unless ( $> );
          
          subtest 'set no write permission deploy path' => sub {

              Enbld::Feature->initialize;

              my $dir = File::Temp->newdir;
              chmod 0444, $dir;

              eval{ Enbld::Feature->set_deploy_mode( $dir ) };
              like( $@, qr/ERROR:no permission to write directory/,
                      'set no write permission' );

              chmod 0755, $dir;
              Enbld::Feature->reset;

              done_testing();
          
          };
};
done_testing();

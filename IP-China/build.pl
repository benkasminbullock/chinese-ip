#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Perl::Build;
perl_build (
    pod => [
        'lib/IP/China.pod',
    ],
    c => [{
        dir => '..',
        stems => ['block-china', 'block-china-data'],
    },],
);
exit;

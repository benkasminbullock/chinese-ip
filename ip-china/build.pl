#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Perl::Build;
perl_build (
    make_pod => "./make-pod.pl",
    c => [{
        dir => '..',
        stems => ['block-china-data'],
    }, {
        dir => '/home/ben/projects/ip-tools',
        stems => ['ip-tools'],
    }],
    clean => "./clean.pl",
);
exit;

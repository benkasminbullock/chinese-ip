#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Perl::Build;
perl_build (
    c => [{
        dir => '..',
        stems => ['block-china', 'block-china-data'],
    },
      ],
);
exit;

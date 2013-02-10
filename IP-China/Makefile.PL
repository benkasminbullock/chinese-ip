use strict;
use warnings;
use ExtUtils::MakeMaker;

my $pm = 'lib/IP/China.pm';
my $repo = 'https://github.com/benkasminbullock/chinese-ip';

WriteMakefile (
    NAME => 'IP::China',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pm,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    LICENSE => 'perl',
    PREREQ_PM => {
    },
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
    OBJECT => 'China.o block-china.o block-china-data.o',
);

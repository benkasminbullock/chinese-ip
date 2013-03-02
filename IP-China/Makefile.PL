use strict;
use warnings;
use ExtUtils::MakeMaker;

my $pm = 'lib/IP/China.pm';
my $pod = 'lib/IP/China.pod';
my $repo = 'https://github.com/benkasminbullock/chinese-ip';

# The list of object files which are compiled with this library.

my $object = 'China.o block-china-data.o';

# I am unable to find a way to make Windows find the functions in
# "IP::Tools", so for Windows users, we include this file in the
# compilation.

if ($^O eq 'MSWin32') {
    $object .= ' ip-tools.o';
}

WriteMakefile (
    NAME => 'IP::China',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pod,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    LICENSE => 'perl',
    PREREQ_PM => {
        'IP::Tools' => 0.01,
    },
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
    OBJECT => $object,
);

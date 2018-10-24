#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use File::Slurper qw!read_text write_text!;
my @c = qw!ip-tools.c block-china-data.c!;
my $output = "#define HEADER 1\n";
my $outfile = 'all.c';
for my $c (@c) {
    my $text = read_text ($c);
    $text =~ s!(#include\s*".*")!/* $1 */!g;
    $output .= "#line 1 \"$c\"\n";
    $output .= $text;
}
$output .= "#undef HEADER\n";

write_text ($outfile, $output);

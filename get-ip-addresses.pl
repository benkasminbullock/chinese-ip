#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Getopt::Long;

my $outfile = 'block-china-data.c';
my $infile = '/home/ben/data/maxmind-geolite/GeoIPCountryWhois.csv';

my $ok = GetOptions (
    "verbose" => \my $verbose,
    "help" => \my $help,
    "outfile=s" => \$outfile,
    "infile=s" => \$infile,
);
if (! $ok || $help) {
    usage ();
    exit;
}

# The following regular expression lists errors found in the list.

my $errata = 

qr/
      "
      (?:
          # This block is owned by Google. It doesn't seem to be
          # located in China, according to whois.

          74\.125\.\d+\.\d+
      )
      "
/x;

my @china;
open my $in, "<", $infile or die $!;
while (<$in>) {
    if (/,\"CN\",/) {
        if (/$errata/) {
            if ($verbose) {
                chomp;
                print "Rejecting $_ as listed in errata.\n";
            }
            next;
        }
        my ($start, $end) = get_start_end ($_);
        push @china, [$start, $end];
    }
}
close $in or die $!;

# Check that the IPs are in sorted order.

my @sorted = sort {$a->[0] <=> $b->[0]} @china;
for my $i (0..$#sorted) {
    if ($sorted[$i] != $china[$i]) {
        die;
    }
}
open my $out, ">", $outfile or die $!;
my $n_china_ips = scalar @china;
print $out <<EOF;
/* This program file includes GeoLite data created by MaxMind,
available from http://www.maxmind.com. The GeoLite databases are
distributed under the Creative Commons Attribution-ShareAlike 3.0
Unported License. */

#include "block-china.h"
int n_china_ips = $n_china_ips;
china_ip_t china_ips[$n_china_ips] = {
EOF
for (@china) {
    my ($start, $end) = @$_;
    printf $out "{0x%X,0x%X},\n", $start, $end;
}
print $out <<EOF;
};
EOF
close $out or die $!;
exit;

# Given a line from the CSV file, get the start and end of the range.

sub get_start_end
{
    my ($line) = @_;
    my (undef, undef, $start, $end) = split /,/, $line;
    $start =~ s/"//g;
    $end =~ s/"//g;
    return $start, $end;
}

# Print a usage message.

sub usage
{
    print <<EOF;
This script converts the MaxMind Geo IP database file into a C file.
The input file is called something like 'GeoIPCountryWhois.csv'. The
output file is called '$outfile'.

--verbose	Print verbose messages on standard output.
--help		Print this message.
--infile <f>	Specify the input file as f.
--outfile <f>	Set the name of the output C file to f.
EOF
    exit;
}

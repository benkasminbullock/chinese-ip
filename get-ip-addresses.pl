#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Getopt::Long;
use IP::Tools ':all';
use Geolite ':all';

my $verbose;
#my $verbose = 1;

my $outfile = 'block-china-data.c';
my $infile = best_geo_file ();
my $additional = 'additional.txt';

my $ok = GetOptions (
    # Debugging flag
    "verbose" => \$verbose,
    "help" => \my $help,
    "outfile=s" => \$outfile,
    "infile=s" => \$infile,
    "additional=s" => \$additional
);

if (! $ok || $help) {
    usage ();
    exit;
}

# The following regular expression lists errors found in the list.

my $errata = 

qr/
      (?:
          # This block is owned by Google. It doesn't seem to be
          # located in China, according to whois.

          74\.125\.\d+\.\d+
      )
/x;

# This contains the list of all the IP address blocks from China.

my @china;

# Read the MaxMind file.

open my $in, "<", $infile or die "Can't open $infile: $!";
while (<$in>) {
    if (/,1814991,/) {
        if (/$errata/) {
            if ($verbose) {
                chomp;
                print "Rejecting $_ as listed in errata.\n";
            }
            next;
        }
        get_start_end (\@china, $_);
    }
}
close $in or die $!;

@china = simplify_blocks (\@china, $verbose);

# Write the C file.

open my $out, ">", $outfile or die $!;
my $n_china_ips = scalar @china;
print $out <<EOF;
/* This program file includes GeoLite data created by MaxMind,
available from http://www.maxmind.com. The GeoLite databases are
distributed under the Creative Commons Attribution-ShareAlike 3.0
Unported License. */

#include <stdint.h>
#include "ip-tools.h"
int n_china_ips = $n_china_ips;
ip_block_t china_ips[$n_china_ips] = {
EOF
for (@china) {
    my ($start, $end) = @$_;
    printf $out "{0x%X, 0x%X},\n", $start, $end;
}
print $out <<EOF;
};
EOF
close $out or die $!;
exit;

# Given a line of the form 1.2.3.4 - 5.6.7.8 from the file specified
# by $additional, push it into the array.

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
--additional <f>	Specify an additional file of addresses.
EOF
    exit;
}


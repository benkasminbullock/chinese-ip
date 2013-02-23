#!/home/ben/software/install/bin/perl
use warnings;
use strict;

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

my $file = '/home/ben/data/maxmind-geolite/GeoIPCountryWhois.csv';
my @china;
open my $in, "<", $file or die $!;
while (<$in>) {
    if (/$errata/) {
        chomp;
        print "Rejecting $_ as listed in errata.\n";
        next;
    }
    if (/,\"CN\",/) {
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
my $outfile = 'block-china-data.c';
open my $out, ">", $outfile or die $!;
my $n_china_ips = scalar @china;
print $out <<EOF;
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

sub get_start_end
{
    my ($line) = @_;
    my (undef, undef, $start, $end) = split /,/, $line;
    $start =~ s/"//g;
    $end =~ s/"//g;
    return $start, $end;
}

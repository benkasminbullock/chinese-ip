#!/home/ben/software/install/bin/perl
use warnings;
use strict;
my $file = '/home/ben/data/maxmind-geolite/GeoIPCountryWhois.csv';
my @china;
open my $in, "<", $file or die $!;
while (<$in>) {
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
my $n_china_ips = scalar @china;
print <<EOF;
#include "block-china.h"
int n_china_ips = $n_china_ips;
china_ip_t china_ips[$n_china_ips] = {
EOF
for (@china) {
    my ($start, $end) = @$_;
    printf "{0x%X,0x%X},\n", $start, $end;
}
print <<EOF;
};
EOF

exit;

sub get_start_end
{
    my ($line) = @_;
    my (undef, undef, $start, $end) = split /,/, $line;
    $start =~ s/"//g;
    $end =~ s/"//g;
    return $start, $end;
}

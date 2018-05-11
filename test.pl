#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use IPC::Run3;
use Deploy 'do_system';
use Test::More;
my $x = './block-china-test';
if (! -f $x) {
    # Don't do "make" here since this script is run by make test.
    die "Rebuild $x";
}
my @tests = (
    # Not Chinese
    ['110.3.244.53' => 0],
    ['68.194.123.246' => 0],
    ['165.79.254.192' => 0],
    # Chinese
    ['101.226.166.226' => -1],
    ['182.118.22.206' => -1],
    ['182.118.20.178' => -1],
    ['182.118.25.237' => -1],
    # Test extrema
    ['255.255.255.255' => 0],
    ['0.0.0.0' => 0],
);
for my $test (@tests) {
    my $ip = $test->[0];
    run3 ([$x, $ip], undef, \my $out, \my $err);
    my $chinese = $test->[1];
    if ($chinese) {
	unlike ($out, qr/not found/i, "$ip found");
    }
    else {
	like ($out, qr/not found/i, "$ip not found");
    }
}
done_testing ();


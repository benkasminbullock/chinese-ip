package IP::China;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/chinese_ip/;
use warnings;
use strict;
our $VERSION = 0.04;
require XSLoader;
XSLoader::load ('IP::China', $VERSION);
1;

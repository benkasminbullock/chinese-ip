package IP::China;
use warnings;
use strict;
require Exporter;
use base qw(Exporter);
our @EXPORT_OK = qw/chinese_ip/;
our $VERSION = '20160412';
require XSLoader;
XSLoader::load ('IP::China', $VERSION);
1;

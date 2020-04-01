use strict;
use warnings;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), qw/lib/),
    File::Spec->catdir(dirname(__FILE__), qw/local lib perl5/),
);

use PingPong::API;

PingPong::API->app();

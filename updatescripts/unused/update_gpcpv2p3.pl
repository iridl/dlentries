#!/usr/bin/perl -w
#
# update_gpcpv2p3.pl
# October 28, 2016
#
# This script updates all monthly GPCP Version 2.3 data files
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;

my $host = 'eagle1.umd.edu';

my $dircdr =qw(/GPCP_CDR/Monthly_Data/);

# get cdr files

@newfiles = ();

chdir "/Data/data7/nasa/gpcp/v2p3/cdr" or die "Couldn't change local directory \n";

@newfiles = getdatafiles("http://$host$dircdr",qr/(gpcp_cdr_v23rB1_y(\d\d\d\d)_m(\d\d).nc$)/);

exit;


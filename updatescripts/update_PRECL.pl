#!/usr/bin/perl -w
 
#Script to update PRECL precipitation datasets from CPC 
# Jan 4, 2019

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $host = 'ftp.cpc.ncep.noaa.gov';				#http host
my $remotedir = qw(/precip/50yr/gauge/0.5deg/format_bin_lnx/);               #array of directories

@newfiles = ();

chdir "/Data/data6/noaa/cpc/precl/v1p0/deg0p5" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

# precl_mon_v1.0.lnx.2018.gri0.5m
# ftp://ftp.cpc.ncep.noaa.gov/precip/50yr/gauge/0.5deg/format_bin_lnx/

@newfiles =  getdatafiles("ftp://$host$remotedir",qr/(precl_mon_v1.0.lnx.\d\d\d\d.gri0.5m$)/);


my $remotedir1 = qw(/precip/50yr/gauge/1.0deg/format_lnx/);               #array of directories

@newfiles1 = ();

chdir "/Data/data6/noaa/cpc/precl/v1p0/deg1p0" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

# precl_mon_v1.0.lnx.2018.gri1.0m
# ftp://ftp.cpc.ncep.noaa.gov/precip/50yr/gauge/1.0deg/format_lnx/

@newfiles1 =  getdatafiles("ftp://$host$remotedir1",qr/(precl_mon_v1.0.lnx.\d\d\d\d.gri1.0m$)/);


my $remotedir2 = qw(/precip/50yr/gauge/2.5deg/format_bin/);               #array of directories
@newfiles2 = ();

chdir "/Data/data6/noaa/cpc/precl/v1p0/deg2p5" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

# precl_mon_v1.0.sgi.2018
# ftp://ftp.cpc.ncep.noaa.gov/precip/50yr/gauge/2.5deg/format_bin/

@newfiles2 =  getdatafiles("ftp://$host$remotedir2",qr/(precl_mon_v1.0.sgi.\d\d\d\d$)/);


exit;

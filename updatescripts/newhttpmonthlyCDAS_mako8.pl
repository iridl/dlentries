#!/usr/bin/perl -w

#Script to update monthly NCEP/NCAR Reanalysis values. 
#Modified from script created download EPTOMS aerosol index files 
#May 26, 2005
#
#Modified on 14 Oct 2014 to pick up data from NCEP ftp site
#due to loss of NOMADS servers

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host
my $dirlola = qw(/wd51we/reanalysis-1/month/grb2d.lola/);               #array of directories
my $dirgau = qw(/wd51we/reanalysis-1/month/grb2d.gau/);               #array of directories
my $dirprs = qw(/wd51we/reanalysis-1/month/prs/);               #array of directories

# get monthly lola CDAS files
chdir "/Data/data6/ncep-ncar/reanI/flux" or die "Couldn't chdir to output directory\n";
getdatafiles("ftp://$host$dirlola",qr/(flx.lola.grib.mean.\d\d\d\d\d\d$)/);

# get monthly gau CDAS files
# There was probably supposed to be a chdir here, but there isn't, so
# we're downloading gau files into the lola directory..
getdatafiles("ftp://$host$dirgau",qr/(flx.gau.grib.mean.\d\d\d\d\d\d$)/);

# get monthly prs CDAS files
chdir "/Data/data6/ncep-ncar/reanI/prs" or die "Couldn't chdir to output directory\n";
getdatafiles("ftp://$host$dirprs",qr/(prs.grib.mean.\d\d\d\d\d\d$)/);

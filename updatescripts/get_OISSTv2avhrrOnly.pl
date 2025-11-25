#!/usr/bin/perl -w

#Script to update OISST AVHHR Only v2 
#Aug 27, 2019

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my $lcldir = '/Data/data21/noaa/ncdc/OI-daily-v2/NetCDF-uncompress/'; 
my $host = 'www.ncei.noaa.gov';				#https host
my $remotedir = '/data/sea-surface-temperature-optimum-interpolation/v2/access/avhrr-only';               #array of directories
@datelist = ();
@newfiles = ();
#@newfiles1 = ();

chomp $lcldir;
chomp $remotedir;

# get daily files

chdir "/Data/data21/noaa/ncdc/OI-daily-v2/NetCDF-uncompress" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  system ("wget --no-check-certificate -A 'avhrr-only-v2.????????.nc' -N -r -l2 -e robots=off -nH --cut-dirs=4 --no-parent https://$host$remotedir/");

system("chmod 644 */avhrr-only-v2.*.nc");

exit;


#!/usr/bin/perl -w

#Script to update PISCO monthly v2.1 unstable 
#Aug 8, 2019

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("pisco_hydro");

my $lcldir = '/Data/data23/SENAMHI/Prec/monthly/unstable/'; 
my $host = 'ftp.senamhi.gob.pe';				#ftp host
my $remotedir = '/PISCO/Prec/V2.1/unstable/monthly';               #array of directories
@datelist = ();
@newfiles = ();

# get monthly files

chdir "/Data/data23/SENAMHI/Prec/monthly/unstable" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  system ("wget --ftp-user=$user --ftp-password=$passwd --no-check-certificate -A '*.tif' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir/");

system("chmod 644 *.tif");

exit;


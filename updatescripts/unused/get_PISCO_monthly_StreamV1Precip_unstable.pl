#!/usr/bin/perl -w

#Script to update PISCO monthly v2.1 ununstable 
#Aug 8, 2019

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("pisco_hydro");

my $lcldir = '/Data/data23/SENAMHI/Stream/v1/unstable/monthly/GR2M/Precip/'; 
my $host = 'ftp.senamhi.gob.pe';				#ftp host
my $remotedir = '/PISCO/Stream/v1/unstable/monthly/GR2M/Precip';               #array of directories
@datelist = ();
@newfiles = ();
#@newfiles1 = ();

chomp $lcldir;
chomp $remotedir;

# get monthly files

chdir "/Data/data23/SENAMHI/Stream/v1/unstable/monthly/GR2M/Precip" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  system ("wget --ftp-user=$user --ftp-password=$passwd --no-check-certificate -A '*.txt' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir/");

system("chmod 644 *.txt");

exit;


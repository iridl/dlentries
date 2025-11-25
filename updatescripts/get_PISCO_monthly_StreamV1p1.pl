#!/usr/bin/perl -w

#Script to update PISCO Streamflow monthly v1.1 ununstable 

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("pisco_prec");

my @vars = ("QR","PR","RU","AE","SM");
my $lcldir = '/Data/data23/SENAMHI/Stream/v1.1/monthly/GR2M/'; 
my $host = 'ftp.senamhi.gob.pe';				#ftp host
my $remotedir = '/PISCO/Q/monthly/PISCO_HyM_GR2M/v1.1/textfiles';               #array of directories

# get monthly files

foreach $var (@vars) {

@datelist = ();
@newfiles = ();

chdir "$lcldir$var/" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  system ("wget --ftp-user=$user --ftp-password=$passwd --no-check-certificate -A '*.txt' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir/$var/");

system("chmod 644 *.txt");

}

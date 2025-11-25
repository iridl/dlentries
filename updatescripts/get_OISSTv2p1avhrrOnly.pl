#!/usr/bin/perl -w

# Script to update OISST AVHHR Only v2.1 
# April 3, 2020

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my $lcldir = '/Data/data21/noaa/ncdc/OI-daily-v2p1/NetCDF/avhrr/'; 
my $host = 'www.ncei.noaa.gov';				#https host
my $remotedir = '/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr';               #array of directories
@newfiles = ();

chomp $lcldir;
chomp $remotedir;

# get daily files

chdir $lcldir or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

for($dm = 0; $dm <=1; $dm++) {
    #data update with ~2 weeks delay so
    #checking today's month and previous
    #Previous will likely check further in the past than needed
    #but that's ok to potentially catch up on mishaps
    $monago = `date -d "$dm month ago" +%m`;
    $yrago = `date -d "$dm month ago" +%Y`;
    chomp $monago;
    chomp $yrago;
    print "$yrago $monago\n";
    $lcldirmon = "$lcldir$yrago$monago" . "/";
    chomp $lcldirmon;
    $remotedirmon = "$remotedir" . "/" . "$yrago$monago";
    chomp $remotedirmon;
    $filename = qr/(oisst-avhrr-v02r01.$yrago$monago\d\d.nc)/;
    if(-d $lcldirmon){
        print "have $lcldirmon already\n";
    } else {
        print $lcldirmon;
        mkdir($lcldirmon);
    }
    if(-d $lcldirmon){
        chdir($lcldirmon) or die "Couldn't change local directory! (1)\n";
        $whatdir = `pwd`;
        print "$whatdir\n";
        @newfiles = getdatafiles("https://$host$remotedirmon/", $filename);
    }
}

exit;


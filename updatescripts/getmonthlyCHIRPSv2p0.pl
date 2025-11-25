#! /usr/bin/perl -w

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

chdir "/Data/data23/UCSB/CHIRPS/v2p0/monthly" or die "Couldn't change directory\n";

@newfiles = ();
@newfiles1 = ();

# assign a two-digit month number for current month in which script is run to $curmon

$curmon = `date +%m`;
$curyr = `date +%Y`;
chomp $curmon;
chomp $curyr;

 $monprevmon = `date -d "1 month ago" +%m`;
 $yrprevmon = `date -d "1 month ago" +%Y`;

#$monprevmon = `date -d "2 month ago" +%m`;
#$yrprevmon = `date -d "2 month ago" +%Y`;
chomp $monprevmon;
chomp $yrprevmon;

print "$monprevmon\n";
print "$yrprevmon\n";

 @newfiles = getdatafiles("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRPS-2.0/global_monthly/tifs/",qr/chirps-v2.0.$yrprevmon.$monprevmon.tif.gz/);
    if(@newfiles) {
	print "downloaded $#newfiles\n";
    }

 @newfiles1 = getdatafiles("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRPS-2.0/global_monthly/tifs/",qr/chirps-v2.0.$yrprevmon.$monprevmon.tif/);
    if(@newfiles1) {
	print "downloaded $#newfiles1\n";
    }

exit;

#! /usr/bin/perl -w

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

chdir "/Data/data23/UCSB/CHIRPS/v2p0/daily-improved/p25" or die "Couldn't change directory\n";

@newfiles = ();
@newfilestest = ();

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

%ndays = qw(01 31 02 28 03 31 04 30 05 31 06 30 07 31 08 31 09 30 10 31 11 30 12 31);
$nday = $ndays{$monprevmon};
chomp $nday;

$mydir = "/Data/data23/UCSB/CHIRPS/v2p0/daily-improved/p25/" . "$yrprevmon";
chomp $mydir;

print "$mydir\n";

$checkdir = $mydir;

if(-d $checkdir){
    print "have $checkdir already\n";
}
else {
    print $mydir;
    mkdir($mydir);
}

$ct = 0;
if(-d $checkdir){
    chdir($mydir) or die "Couldn't change local directory! (1)\n";

# check to see if you have the latest month's files already
    $lclct = 0;
    foreach $localfile (<chirps-v2.0.*.tif>){
      if($localfile =~ /chirps-v2.0.$yrprevmon.$monprevmon.\d\d.tif/) {
        print "$localfile\n";
        ++$lclct;
      }
    }

# if you have all the latest month's files already, end the update script before you try to download
    if($lclct >= $nday) {
      print "Already have all the latest files. Stopping update script.\n";
      exit;
    }

    @newfilestest = getdatafilesdirect("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRPS-2.0/global_daily/tifs/p25/$yrprevmon/",qr/chirps-v2.0.$yrprevmon.$monprevmon.01.tif*/);
#   @newfiles = system("wget -N ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRPS-2.0/global_daily/tifs/p25/$yrprevmon/chirps-v2.0.$yrprevmon.$monprevmon.*.tif*");

    if(@newfilestest) {
        foreach $fil (@newfilestest) {
           if($fil =~ /chirps-v2.0.*.01.tif/) {
               $ct = 1;
           }
        }
    }    

    if($ct == 1) {
        print "File for the first day of $monprevmon is available.  Continue downloading.\n";
        @newfiles = getdatafilesdirect("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRPS-2.0/global_daily/tifs/p25/$yrprevmon/",qr/chirps-v2.0.$yrprevmon.$monprevmon.\d\d.tif*/);
        print "downloaded $#newfiles\n";
    } else { 
        print "No files available for download; stop trying for now\n";
    }

}

#getdatafiles("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRPS-2.0/global_daily/tifs/p25/2017/",qr/chirps-v2.0.2017.06.\d\d.tif.gz/);
#getdatafiles("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRPS-2.0/global_daily/tifs/p25/2017/",qr/chirps-v2.0.2017.06.\d\d.tif/);

exit;

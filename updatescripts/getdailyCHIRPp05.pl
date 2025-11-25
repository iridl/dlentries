#! /usr/bin/perl -w

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

chdir "/Data/data23/UCSB/CHIRP/v1p0/daily/p05" or die "Couldn't change directory\n";

@newfiles = ();
@newfilestest = ();

# assign a two-digit month number for current month in which script is run to $curmon

$curmon = `date +%m`;
$curyr = `date +%Y`;
chomp $curmon;
chomp $curyr;

$monprevmon = `date -d "1 month ago" +%m`;
$yrprevmon = `date -d "1 month ago" +%Y`;

chomp $monprevmon;
chomp $yrprevmon;

print "$monprevmon\n";
print "$yrprevmon\n";

%ndays = qw(01 31 02 28 03 31 04 30 05 31 06 30 07 31 08 31 09 30 10 31 11 30 12 31);
$nday = $ndays{$monprevmon};
chomp $nday;

$mydir = "/Data/data23/UCSB/CHIRP/v1p0/daily/p05/" . "$yrprevmon";
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

if(-d $checkdir){
    chdir($mydir) or die "Couldn't change local directory! (1)\n";

 @newfiles = getdatafilesdirect("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRP/daily/$yrprevmon/",qr/chirp.$yrprevmon.$monprevmon.\d\d.tif*/);
 print "downloaded $#newfiles\n";

}

$mydir1 = "/Data/data23/UCSB/CHIRP/v1p0/daily/p05/" . "$curyr";
chomp $mydir1;

print "$mydir1\n";

$checkdir1 = $mydir1;

if(-d $checkdir1){
    print "have $checkdir1 already\n";
}
else {
    print $mydir1;
    mkdir($mydir1);
}

if(-d $checkdir1){
    chdir($mydir1) or die "Couldn't change local directory! (1)\n";


 @newfiles1 = getdatafilesdirect("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRP/daily/$curyr/",qr/chirp.$curyr.$curmon.\d\d.tif*/);
 print "downloaded $#newfiles1\n";

}

#getdatafiles("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRP/daily/2017/",qr/chirp.2017.06.\d\d.tif.gz/);
#getdatafiles("ftp://ftp.chc.ucsb.edu/pub/org/chc/products/CHIRP/daily/2017/",qr/chirp.2017.06.\d\d.tif/);

exit;

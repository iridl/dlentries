#! /usr/bin/perl -w

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

chdir "/Data/data21/OSU/PRISM/US" or die "Couldn't change directory\n";

@newfiles = ();

# assign a two-digit month number for current month in which script is run to $curmon

$curmon = `date +%m`;
$curyr = `date +%Y`;
chomp $curmon;
chomp $curyr;

$yrprevmon12 = `date -d "12 month ago" +%Y`;

$yrprevmon1 = `date -d "1 month ago" +%Y`;

chomp $yrprevmon12;
chomp $yrprevmon1;

print "$yrprevmon12\n";
print "$yrprevmon1\n";

# ppt tdmean tmax tmean tmin vpdmax vpdmin

my @longvar = ("ppt_stable_4kmM3","tdmean_stable_4kmM1","tmax_stable_4kmM2","tmean_stable_4kmM2","tmin_stable_4kmM2","vpdmax_stable_4kmM1","vpdmin_stable_4kmM1");
my @shortvar = ("ppt","tdmean","tmax","tmean","tmin","vpdmax","vpdmin");

for ($i = 0; $i <= 6; $i++) {  # loop through variables

# There is about a 6-month lag before the stable version of the data becomes available.  To cover possible recent updates for this year and last
# year, look back at the year from 12 months ago and then look back at the year from 1 month ago.

 $mydir12 = "/Data/data21/OSU/PRISM/US/$shortvar[$i]/" . "$yrprevmon12";
 chomp $mydir12;

 print "$mydir12\n";

 $checkdir12 = $mydir12;

 if(-d $checkdir12){
    print "have directory $checkdir12 already\n";
 }
 else {
    print "$mydir12\n";
    mkdir($mydir12);
 }

# ftp://prism.nacse.org/monthly/ppt/2018/PRISM_ppt_stable_4kmM3_201801_bil.zip
# ftp://prism.nacse.org/monthly/tdmean/2018/PRISM_tdmean_stable_4kmM1_201801_bil.zip
# ftp://prism.nacse.org/monthly/tmax/2018/PRISM_tmax_stable_4kmM2_201801_bil.zip
# ftp://prism.nacse.org/monthly/tmean/2018/PRISM_tmean_stable_4kmM2_201801_bil.zip
# ftp://prism.nacse.org/monthly/tmin/2018/PRISM_tmin_stable_4kmM2_201801_bil.zip
# ftp://prism.nacse.org/monthly/vpdmax/2018/PRISM_vpdmax_stable_4kmM1_201801_bil.zip
# ftp://prism.nacse.org/monthly/vpdmin/2018/PRISM_vpdmin_stable_4kmM1_201801_bil.zip
#

 if(-d $checkdir12){
    chdir($mydir12) or die "Couldn't change local directory! (1)\n";
    @newfiles = getdatafiles("ftp://prism.nacse.org/monthly/$shortvar[$i]/$yrprevmon12/",qr/PRISM_$longvar[$i]_$yrprevmon12\d\d_bil.zip/);
#   @newfiles = system("wget -N ftp://prism.nacse.org/monthly/ppt/$yrprevmon/PRISM_ppt_stable_4kmM3_$yrprevmon??_bil.zip");
    if(@newfiles) {
	print "downloaded $#newfiles\n";
        foreach $fil (@newfiles) {
            my $tst1 = system( 'unzip', "$mydir12" . "/" . "$fil");
            print "$tst1\n";
        }
    }
 }

 @newfiles = ();
 $fil = ();

 $mydir1 = "/Data/data21/OSU/PRISM/US/$shortvar[$i]/" . "$yrprevmon1";
 chomp $mydir1;

 print "$mydir1\n";

 $checkdir1 = $mydir1;

 if(-d $checkdir1){
    print "have directory $checkdir1 already\n";
 }
 else {
    print "$mydir1\n";
    mkdir($mydir1);
 }

 if(-d $checkdir1){
    chdir($mydir1) or die "Couldn't change local directory! (2)\n";
    @newfiles = getdatafiles("ftp://prism.nacse.org/monthly/$shortvar[$i]/$yrprevmon1/",qr/PRISM_$longvar[$i]_$yrprevmon1\d\d_bil.zip/);
#   @newfiles = system("wget -N ftp://prism.nacse.org/monthly/ppt/$yrprevmon/PRISM_ppt_stable_4kmM3_$yrprevmon??_bil.zip");
    if(@newfiles) {
	print "downloaded $#newfiles\n";
        foreach $fil (@newfiles) {
            my $tst2 = system( 'unzip', "$mydir1" . "/" . "$fil");
            print "$tst2\n";
        }
    }
 }

} # end loop indexing $i through variables

exit;

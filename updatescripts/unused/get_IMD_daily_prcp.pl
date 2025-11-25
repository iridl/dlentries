#!/usr/bin/perl -w

#Script to download real-time daily gridded precip. on 0.25 deg. lat/lon grid from daily files 
#Modified from script created to download MONTHLY CDAS
#Sep 12, 2017

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my ($username, $password) = get_credential("imd_daily");

my $lcldir = '/Data/data6/IMD/daily/gridded/precip/IMD-0p25-RT/'; 
my $host = '210.212.167.211';				#ftp host
my $remotedir = qw(/real_time2017/);               #array of directories
@datelist = ();
@newfiles = ();

# assign a two-digit month number for current month in which script is run to $curmon
#$curmon = "07";
$curday = `date +%d`;
$curmon = `date +%m`;
$curmonb = `date +%b`;
$curyr =  `date +%Y`;
$curyrabbr = `date +%y`;
chomp $curday;
chomp $curmon;
chomp $curmonb;
chomp $curyr;
chomp $curyrabbr;

for($dy = -10; $dy <=0; $dy++) {
# begin a loop that starts with -20 and goes to zero. As this loops, assign each day to $dy 

 $loopyr = `date -d "$curday $curmonb $curyr + $dy days" +%Y`;
 $loopmon = `date -d "$curday $curmonb $curyr + $dy days" +%m`;
 $loopday = `date -d "$curday $curmonb $curyr + $dy days" +%d`;
 $loopyrshort = `date -d "$curday $curmonb $curyr + $dy days" +%y`;
 chomp $loopyr;
 chomp $loopmon;
 chomp $loopday;
 chomp $loopyrshort;

 print "$loopyr $loopmon\n";

# convert two-digit month number to lowercase full month name and assign to %monname
 %monname = qw(01 JANUARY 02 FEBRUARY 03 MARCH 04 APRIL 05 MAY 06 JUNE 07 JULY 08 AUGUST 09 SEPTEMBER 10 OCTOBER 11 NOVEMBER 12 DECEMBER);
 $remcurmon = $monname{$loopmon};
 chomp $remcurmon;

 $remcurmondir = "$remcurmon" . "$loopyr" . "/";
 chomp $remcurmondir;

# convert two-digit month number to 3-letter month abbr. and assign to $nmon

 %monabbr = qw(01 JAN 02 FEB 03 MAR 04 APR 05 MAY 06 JUN 07 JUL 08 AUG 09 SEP 10 OCT 11 NOV 12 DEC);
 $nmon = $monabbr{$loopmon};
 chomp $nmon;

 print "$remcurmondir\n";

# FEB0718f.grd
 $filnam = "$nmon" . "$loopday" . "$loopyrshort" . "f.grd"; 
 chomp $filnam;

 print "$filnam\n";

# get monthly files

 chdir "/Data/data6/IMD/daily/gridded/precip/IMD-0p25-RT" or die "Couldn't change
 local directory! (1)\n";

 $whatdir = `pwd`;
 print "$whatdir\n";

 system ("wget --ftp-user=$username --ftp-password=$password -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir$remcurmondir$filnam");

#@newfiles =  getdatafiles("ftp://$host$remotedir$remcurmondir",qr/([A-Z][A-Z][A-Z]\d\d\d\df.grd$)/);

} # end of for loop

exit;

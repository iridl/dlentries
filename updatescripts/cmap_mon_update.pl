#!/usr/bin/perl -w

#Script to download CMAP monthly precipitation data every month. 

# run this on gfs2mon1 
# Dec 9, 2019

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my $lcldir = '/Data/data5/noaa/cac/cmap/monthly/'; 
my $latdir = '/Data/data5/noaa/cac/cmap/monthly/latest_rotating/'; 
# ftp://ftp.cpc.ncep.noaa.gov/precip/cmap/monthly/
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host
my $remotedir = qw(/precip/cmap/monthly/);               #array of directories

@datelist = ();
@newfiles1 = ();

# assign a two-digit month number for current month in which script is run to $curmon
#$curmon = "02";
$curmon = `date +%m`;
$curyr = `date +%Y`;
$curyr2dig = `date +%y`;
chomp $curmon;
chomp $curyr;
chomp $curyr2dig;

$minus1 = "-1 month";
chomp $minus1;
$prevmonmon = `date -d "$curyr-$curmon-01 $minus1" +%m`;
$prevmonyr = `date -d "$curyr-$curmon-01 $minus1" +%Y`;
chomp $prevmonmon;
chomp $prevmonyr;

# convert two-digit month number to 3-letter month abbr. and assign to $nmon

%monabbr = qw(01 Jan 02 Feb 03 Mar 04 Apr 05 May 06 Jun 07 Jul 08 Aug 09 Sep 10 Oct 11 Nov 12 Dec);
$nmon = $monabbr{$curmon};
chomp $nmon;
$prevnmon = $monabbr{$prevmonmon};
chomp $prevnmon;
$verdir = "v" . "$curyr2dig" . "$curmon";
chomp $verdir;
print "$verdir\n";
$verdirfull = "/Data/data5/noaa/cac/cmap/monthly/" . "$verdir";
chomp $verdirfull;
print "$verdirfull\n";

chdir "/Data/data5/noaa/cac/cmap/monthly" or die "Couldn't change local directory! (1)\n";

if (! -e $verdirfull) {mkdir "$verdirfull" or die "Couldn't make version directory!\n";}

chdir "$verdirfull" or die "Couldn't change to version directory\n";

$whatdir = `pwd`;
print "$whatdir\n";

$filbase = "cmap_mon_v" . "$curyr2dig" . "$curmon" . "_"; 

# ftp://ftp.cpc.ncep.noaa.gov/precip/cmap/monthly/
# cmap_mon_v1911_88.txt

 @newfiles1 =  getdatafiles("ftp://$host$remotedir",qr/($filbase\d\d.txt.gz$)/);

#@newfiles1 =  system ("wget -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd ftp://$host$remotedir");

 foreach $fil (@newfiles1) {
  if ($fil=~/cmap_mon_v(\d\d\d\d)_00.txt/) {
   push(@datelist,$1);
  } # end if
  if ($fil =~ /cmap_mon_v(\d\d\d\d)_(\d\d).txt/) {
   system("cp $fil $latdir/cmap_mon_latest_$2.txt");
   print "$fil\n";
   print "$latdir/cmap_mon_latest_$2.txt\n";#
  } # end if
 } # end foreach

 print "@datelist\n";

 @sorteddates = sort by_number @datelist;

 $lastdate = $sorteddates[-1];
 chomp $lastdate;

 if($lastdate =~ m/(\d\d)(\d\d)$/) {
  $lastdateyr2 = $1;
  $lastdatemon = $2; 
  chomp $lastdateyr2;
  chomp $lastdatemon;
  print "$lastdateyr2\n";
  print "$lastdatemon\n";
 }

chdir "/Data/data5/noaa/cac/cmap/monthly/latest_rotating" or die "Couldn't change local directory! (2)\n";

# write date of current end  month (month before CMAP version month) to a file to hold the end date as 16 Mmm YYYY format and read this with index.tex file
 if(($lastdatemon == $curmon) && ($lastdateyr2 == $curyr2dig)) {
  open(out1,">endmonth.txt") || die "Couldn't write to endmonth.txt: $!";
    print out1 "\\begin{ingrid}\n";
    print out1 "$prevnmon $prevmonyr\n";
    print out1 "\\end{ingrid}\n";
  close(out1);
 }

 sub by_number {
  if ($a < $b) {
   return -1;
  } elsif ($a == $b) {
   return 0;
  } elsif ($a > $b) {
   return 1;
  }
 }

exit;




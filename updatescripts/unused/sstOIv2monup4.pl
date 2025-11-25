#! /usr/bin/perl -w
#$mondir="pub/cmb/sst/oimonth_v2";
#perl script to update monthly Reynolds and Smith OIv2 sst dataset without modifying associated index.tex file
# M. Bell, 19 Feb 2015
# run on gfs2geo1 and gfs2mon1

$local="/Data/data3/ocean/nmc/RSOIver2/monthly";
$gnudate="/bin/date";

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

@newfiles = ();

chdir "$local" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

#@newfiles = getdatafiles("ftp://ftp.emc.ncep.noaa.gov/cmb/sst/oimonth_v2/",qr/oiv2mon\.\d\d\d\d\d\d.gz$/);
@newfiles = getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/precip/PORT/sst/oimonth_v2/",qr/oiv2mon\.\d\d\d\d\d\d.gz$/);

# Get the 2-digit month and 4-digit year for the month preceding the month in which the update script runs.  If the script is getting a data file
# for the most recent available month, this date should match the month and year indicated in the most recent filename.  This needs to be 
# checked to make sure that data from the most recent month is being downloaded so that the correct date is sent to the script that updates
# the Kaplan Extended dataset.

$prevmon = `$gnudate -d "-1 month" +%m`;
$yrprevmon = `$gnudate -d "-1 month" +%Y`; 
chomp $prevmon;
chomp $yrprevmon;

# set up hash to associate 2-digit month number with 3-letter month abbr.
%monabbr = qw(01 Jan 02 Feb 03 Mar 04 Apr 05 May 06 Jun 07 Jul 08 Aug 09 Sep 10 Oct 11 Nov 12 Dec);

if(@newfiles) {
 foreach $newfileuz (@newfiles) { 
  system("gzip $newfileuz");

  if($newfileuz =~ m/oiv2mon\.(\d\d\d\d)(\d\d)$/) {
   $yr = $1;
   $mon = $2;
   chomp $yr;
   chomp $mon;
# if year and month in name of downloaded file matches the year and month from the month before the script is run, assign year to $nyr and 3-letter 
# abbreviation for month to $nmon and use them as arguments in the script that updates the Kaplan Extended dataset
   if(($mon eq $prevmon) && ($yr eq $yrprevmon)) {
    $nyr = $yr;
    $nmon = $monabbr{$mon};
    chomp $nyr;
    chomp $nmon;
# new access to markov from mako8 -- 9 Apr 2013 -- to update Kaplan Extended using RSOIv2 data
    system("./mkxHSST2.sh $nmon $nyr");

     print "Monthly SST update -- Reynolds and Smith OI v.2\n";
     print "Found new files at NCEP.\n";
     print "Update month is $nmon $nyr \n";

   } # end of if(($mon...
  } # end of if($newfileuz...
 } # end of foreach
} # end of if(@newfiles...
exit;


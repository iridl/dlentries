#!/usr/bin/perl -w

#Script to update selected indices from CPC 
#Feb 19, 2014

# test this script in home directory

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my $lcldir = '/Data/data1/noaa/indices/'; 
#my $host = 'www.cpc.ncep.noaa.gov';				#ftp host
#my $remotedir = qw(/data/indices/);               #array of directories
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host
my $remotedir = qw(/wd52dg/data/indices/);               #array of directories
@datelist = ();
@newfiles = ();

# assign two-digit month number for current month in which script is run to $curmon
$curmon = `date +%m`;
chomp $curmon;

$curdate = `date +%Y%m`;
chomp $curdate;

print "$curdate\n";

# get updated files

 chdir "/Data/data1/noaa/indices" or die "Couldn't change local directory! (1)\n";
#chdir "/data/mbell/dldata/indices.d" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  getdatafiles("ftp://$host$remotedir",qr/(darwin$)/);
#@newfiles =  getdatafiles("https://$host$remotedir",qr/(darwin$)/);

@newfiles2 = getdatafiles("ftp://$host$remotedir",qr/(tahiti$)/);
#@newfiles2 = getdatafiles("https://$host$remotedir",qr/(tahiti$)/);

@newfiles3 = getdatafiles("ftp://$host$remotedir",qr/(soi$)/);
#@newfiles3 = getdatafiles("https://$host$remotedir",qr/(soi$)/);

# if a new darwin file was downloaded, split the file into three files -- one containing the full values,
# one containing the CPC-calculated anomalies, and one containing the CPC-calculated standardized index
#
# then, concatenate the 1951- values from the file of full values with the values from the file of
# full values from 1882 to 1950 to produce a new file that has the newest monthly value within the 
# 1882 to present series
#

#@newfiles = "darwin";
#@newfiles2 = "tahiti";
#@newfiles3 = "soi";

if(@newfiles) {

 system("csplit -f darwin1 darwin /ANOMALY/-1 /STANDARDIZED/-1 ; grep '^[0-9][0-9][0-9][0-9]' darwin100 > darwin.orig.update ; cat darwin.1882_1950 darwin.orig.update > darwin.full ; mv darwin101 darwin.anom ; mv darwin102 darwin.stan");


# csplit searches for lines in "darwin" file containing "ANOMALY" and "STANDARDIZED", and splits at 2 lines before, into three
# files since two split points (ANOMALY and STANDARDIZED) are specified.  Output files are named "darwin1" with 00, 01, and 02
# suffixes

# rename the files that you split away to indicate full values, anomalies, and standardized
# but calculate your own anomalies and standardized anomalies and serve them categorized with
# their base period

} 

if(@newfiles2) {

 system("csplit -f tahiti1 tahiti /ANOMALY/-1 /STANDARDIZED/-1 ; mv tahiti100 tahiti.full ; mv tahiti101 tahiti.anom ; mv tahiti102 tahiti.stan");

# rename the files that you split away to indicate full values, anomalies, and standardized
# but calculate your own anomalies and standardized anomalies and serve them categorized with
# their base period

} 

if(@newfiles3) {

 system("csplit -f soi1 soi /STANDARDIZED/-1 ; mv soi100 soi.anom ; mv soi101 soi.stan");

# rename the files that you split away to indicate anomalies, and standardized
# but calculate your own anomalies and standardized anomalies and serve them categorized with
# their base period

} 

 print "@newfiles\n";
 print "@newfiles2\n";
 print "@newfiles3\n";

exit;

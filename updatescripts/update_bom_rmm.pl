#!/usr/bin/perl -w
#
# update_bom_rmm.pl
# Oct 29, 2015
#
# This script updates the BoM MJO RMM daily data file, 1 Jun 1974-present
# without modifying the index.tex file that describes it.  Run on gfs2geo1 and gfs2mon1
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;
#

use POSIX;

$gnudate="/bin/date";

my $host = 'reg.bom.gov.au';

my $dirs =qw(/clim_data/IDCKGEM000/);

# get file

@newfile = ();

$fil = "rmm.74toRealtime.txt";

chdir "/Data/data8/BoM/MJO" or die "Couldn't change local directory \n";

@newfiles = system("wget -t 10 -o log -N -r -l1 -e robots=off --no-parent -nd http://$host$dirs$fil");

if(@newfiles) {

  $lastline = `cat $fil | tail -n 1`;
# pull out the last line from the data file to get at the date for the latest data 
  chomp $lastline;

 print "$lastline";

 @fields = ();
 @fields = split(/\s+/, $lastline);
 print "@fields\n";
 $yr = $fields[1];
 $curmon = $fields[2];
 $da = $fields[3];
# pull out the latest date of data 
 chomp $yr;
 chomp $curmon;
 chomp $da;

 print "$yr $curmon $da\n";

 %monabbr = qw(1 Jan 2 Feb 3 Mar 4 Apr 5 May 6 Jun 7 Jul 8 Aug 9 Sep 10 Oct 11 Nov 12 Dec);
 $nmon = $monabbr{$curmon};
 chomp $nmon;

 print "$da $nmon $yr\n";
# write to a file to hold the end date as dd Mmm YYYY format and read this from index.tex file
 open(out1,">enddate.txt") || die "Couldn't write to enddate.txt: $!";
   print out1 "\\begin{ingrid}\n";
   print out1 "$da $nmon $yr\n";
   print out1 "\\end{ingrid}\n";
 close(out1);

}

exit;

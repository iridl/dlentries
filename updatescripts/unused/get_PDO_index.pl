#!/usr/bin/perl -w
#
# Script to update PDO index from JISAO
# Oct 17, 2016

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my $lcldir = '/Data/data23/JISAO/PDO/';
my $host = 'research.jisao.washington.edu';
my $remotedir = qw(/pdo/);
my $dloadfile = 'PDO.latest.txt';
@datelist = ();
@newfiles = ();

# assign two-digit month number for current month in which script is run to $curmon

$curmon = `date +%m`;
chomp $curmon;

$curdate = `date +%Y%m`;
chomp $curdate;

print "$curdate\n";

# get updated files

chdir "/Data/data23/JISAO/PDO" or die "Couldn't change local directory. (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

$newfiles = system("curl", "http://research.jisao.washington.edu/pdo/PDO.latest.txt", "-o", $dloadfile);

#@newfiles = getdatafiles("http://$host$remotedir$dloadfile");
#@newfiles = getdatafiles("http://$host$remotedir",qr/(PDO.latest.txt$)/);

# if a new PDO file is downloaded, use grep to read through the file and
# pull out only the time series data into a separate file to make file
# easier to read for Ingrid

if(@newfiles == 0) {

 system("grep '^[0-9][0-9][0-9][0-9]' PDO.latest.txt > PDO.latest.data.txt");

 print "@newfiles\n";

 $lastline = `cat PDO.latest.data.txt | tail -n 1`;
# pull out the last line from the data file to get at the date for the latest data

 chomp $lastline;

 @fields = ();
 @fields = split(/\s+/, $lastline);
 print "@fields\n";

 $yr = substr($fields[0],0,4);
 chomp $yr;

 $numfields = @fields;
 chomp $numfields;

# start with 2=Jan here because the first field holds the year, the second field holds the Jan value 
 %monabbr = qw(2 Jan 3 Feb 4 Mar 5 Apr 6 May 7 Jun 8 Jul 9 Aug 10 Sep 11 Oct 12 Nov 13 Dec);


 $mon = $monabbr{$numfields};
 chomp $mon;

 print "$yr $mon\n";

#system("cat PDO.latest.data.txt | sed 's/ \+/\t/g' > PDO.latest.data.tsv");
 system("cat PDO.latest.data.txt | tr -s [:blank:] | cut -d' ' -f2-13 > PDO.latest.dataonly.txt");

# write to a file to hold the end date as Mmm YYYY format and read this from index.tex file
  
 open(out1,">enddate.txt") || die "Couldn't write to enddate.txt: $!";
  print out1 "\\begin{ingrid}\n";
  print out1 "16 $mon $yr\n";
  print out1 "\\end{ingrid}\n";
 close(out1);
}

exit;


#!/usr/bin/perl -w
#
# update_ghcn_cams_temp3.pl
# June 2, 2015
#
# This script updates the CPC GHCN_CAMS 0.5 deg. resolution global monthly temperature data file, 1948-present
# without modifying the index.tex file that describes it.  Run on gfs2geo1 and gfs2mon1
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;

$gnudate="/bin/date";
#$indextex="/Data/data1/DataCatalog/entries/NOAA/NCEP/CPC/GHCN_CAMS/gridded";
my $host = 'ftp.cpc.ncep.noaa.gov';

my $dirs =qw(/wd51yf/GHCN_CAMS/);

$dataset = "SOURCES .NOAA .NCEP .CPC .GHCN_CAMS .gridded .deg0p5 .temp";
chomp $dataset;

$prevenddate=askingrid("$dataset T last dup subgrid (%Y.%m) strftimes data.ch");
chomp $prevenddate;

print "$prevenddate\n";

$prevyr = substr($prevenddate,0,4);
$prevmon = substr($prevenddate,5,2);
$nextmon = substr($prevenddate,5,2) + 1;
chomp $prevyr;
chomp $prevmon;
chomp $nextmon;

print "$prevmon $prevyr\n";

if($nextmon == 13){
 $nextmon = 1;
 $nyr = $prevyr + 1;
} else {
 $nyr = $prevyr;
}

%monabbr = qw(1 Jan 2 Feb 3 Mar 4 Apr 5 May 6 Jun 7 Jul 8 Aug 9 Sep 10 Oct 11 Nov 12 Dec);
$nmon = $monabbr{$nextmon};
chomp $nmon;
chomp $nyr;

# get file

@newfiles = ();

chdir "/Data/data6/noaa/cpc/ghcn_cams/monthly/gridded" or die "Couldn't change local directory \n";

$filename = '/Data/data6/noaa/cpc/ghcn_cams/monthly/gridded/ghcn_cams_1948_cur.grb';
$filesize1 = -s $filename;
print "$filesize1\n";

@newfiles = getdatafiles("ftp://$host$dirs",qr/(ghcn_cams_1948_cur.grb$)/);

#@newfiles = "ghcn_cams_1948_cur.grb";

if(@newfiles) {

 foreach $fil (@newfiles) { 
   $filesize2 = -s $fil;
 }

 print "$filesize2\n";

 if($filesize2 > $filesize1) {

  print "$nmon $nyr\n";
# write to a file to hold the end date as Mmm YYYY format and read this from index.tex file
  open(out1,">endmonth.txt") || die "Couldn't write to endmonth.txt: $!";
   print out1 "\\begin{ingrid}\n";
   print out1 "$nmon $nyr\n";
   print out1 "\\end{ingrid}\n";
  close(out1);
 }
}

exit;

sub askingrid {
    my ($ask) = @_;
    my $returnvalue;
#
# funky perl -- splits into two processes that talk to each other
    unless(open(IN, '-|'))
    { 
# input (kid) process: runs ingrid
# notice that open(IN,'-|') is 0 in the kid process,
# but it equals the kid process' ID in the dad process,
# hence the need for the "unless" above (according to the sage Camel).
     	if (open(OUT,"|/usr/local/bin/ingrid")) {
 	    print OUT <<"eof";
 
to get beyond last known date from ingrid
\\begin{ingrid}
defHTMLwords HTMLwords
$ask
\\end{ingrid}
eof
    close(OUT);
    	}
	else {
    print("ingrid failed\n");
   	};
	exit;  # you need to exit the spawned kid process
    };
# output (dad) process: reads output of ingrid
# ... dad listens to the kid, but allways has the final word ...
    $returnvalue=<IN>;
    close(IN);
    $returnvalue=~ s/[\r]?[\n]?$//;
    return $returnvalue;
}


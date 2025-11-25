#! /usr/bin/perl -w
use POSIX qw/strftime/;
use Date::Manip;
# https://e4ftl01.cr.usgs.gov/MOLT/MOD11A2.006/2020.12.18/
# copies 1 km TERRA from https://e4ftl01.cr.usgs.gov/MOLT/MOD11A2.006/YYYY.MM.DD/
# test case http://e4ftl01.cr.usgs.gov/MOLT/MOD11A2.006/2020.12.18/  
# data files sent to /Data/data22/usgs/landdaac/MOLT/MOD11A2.006/YYYY.MM.DD

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles_nasa.pl";
#require "/home/datag/perl/getdatafiles_nasa.pl";

$targetfilecount="317";
$hostname="e4ftl01.cr.usgs.gov";
$subdir="MOLT/MOD11A2.006";
$mydir="/Data/data22/usgs/landdaac/" . $subdir . '/';
chdir($mydir)or die "$mydir not found\n";
# checks all directories for changed files
if ($ARGV[0] eq "all" || $ARGV[0] eq "last" ) {
    print "checking all data directories\n";
@dates = getdatadirectories("https://$hostname/$subdir/",qr/(\d\d\d\d)\.(\d\d)\.(\d\d)/);
#@dates = getdatadirectories("https://$hostname/$subdir/",qr/(2020)\.(12)\.(18)/);
    if($ARGV[0] eq "last"){
	@dates = ( $dates[$#dates]);
}
}
elsif(!$ARGV[0]) {
# only checks changed directories for changed/new files
    print "checking changed data directories\n";
@dates = makedatadirectories("https://$hostname/$subdir/",qr/(\d\d\d\d)\.(\d\d)\.(\d\d)/);
#@dates = makedatadirectories("https://$hostname/$subdir/",qr/(2020)\.(12)\.(18)/);
}
else {
    $datepat = $ARGV[0];
@dates = getdatadirectories("https://$hostname/$subdir/",qr/(\d\d\d\d)\.(\d\d)\.(\d\d)/);
#@dates = getdatadirectories("https://$hostname/$subdir/",qr/(2020)\.(12)\.(18)/);
}
foreach $thedate (@dates){
    print $thedate;
    if(!$datepat || $thedate=~ m/^$datepat/){
if($thedate=~ m/(\d\d\d\d)\.(\d\d)\.(\d\d)/){
    $year=$1;
    $mon=$2;
    $day=$3;
    $doy=sprintf("%3.3d",&Date_DayOfYear($mon,$day,$year));
}
system("date");
print "\n$thedate $year $doy\n";
if("1"){
$myddir="$mydir/$thedate/";
if(! -e $myddir ){
system("mkdir -p $myddir");
}
chdir($myddir)or die "$myddir not found\n";
print "downloading to $myddir\n";
foreach $file (getdatafiles("https://$hostname/$subdir/$thedate/",qr/.hdf$/)){ 
print "got $file\n";
}
my $filecount = `find $myddir -name '*.hdf' -type f ! -name filecount  | wc -l`;
$process="";
chop $filecount;
if($filecount >= $targetfilecount){
if(! -e "$myddir/filecount" ){
    $process="1";
    system("echo $filecount > $myddir/filecount");
}
}
    print "Have $filecount of $targetfilecount files for $year $mon $day\n";

#processes tiles for old versions
    $set="A$year$doy";
if($process){
print "processing tiles for old versions";
    $set="A$year$doy";
    system("nice -19 /Data/data8/usgs/landdaac/processdata1kmTERRA_v006-use $set $year $doy $thedate");
}
else {
    print "don't need to run processdata1kmTERRA_v006-use $set $year $doy $thedate\n";
}
}
}
}


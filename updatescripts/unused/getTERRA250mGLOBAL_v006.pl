#! /usr/bin/perl -w
use POSIX qw/strftime/;
use Date::Manip;

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles_nasa.pl";
#require "/home/datag/perl/getdatafiles_nasa.pl";

# target file count actually varies
$targetfilecount="274";
$hostname="e4ftl01.cr.usgs.gov";
$subdir = "MOLT/MOD13Q1.006";
#$mydir="/data/dstore3/iri/monitoring/data/data8/usgs/landdaac/$subdir/";
# change from dstore to /Data/data8
$mydir="/Data/data8/usgs/landdaac/$subdir/";
#$mydir="/Data/data8/usgs/landdaac/MOLT/MOD13Q1.006_test/";
chdir($mydir)or die "$mydir not found\n";
# checks all directories for changed files
if ($ARGV[0] eq "all" || $ARGV[0] eq "last" ) {
    print "checking all data directories\n";
@dates = getdatadirectories("https://$hostname/$subdir/",qr/(\d\d\d\d)\.(\d\d)\.(\d\d)/);
#@dates = getdatadirectories("https://$hostname/$subdir/",qr/(2020)\.(12)\.(02)/);
    if($ARGV[0] eq "last"){
	@dates = ( $dates[$#dates]);
    }
}
elsif(!$ARGV[0]) {
# only checks changed directories for changed/new files
    print "checking changed data directories\n";
@dates = makedatadirectories("https://$hostname/$subdir/",qr/(\d\d\d\d)\.(\d\d)\.(\d\d)/);
#@dates = makedatadirectories("https://$hostname/$subdir/",qr/(2020)\.(12)\.(02)/);
print "@dates\n";
}
else {
    $datepat = $ARGV[0];
@dates = getdatadirectories("https://$hostname/$subdir/",qr/(\d\d\d\d)\.(\d\d)\.(\d\d)/);
#@dates = getdatadirectories("https://$hostname/$subdir/",qr/(2020)\.(12)\.(02)/);
}
print "number of dates $#dates\n";
print "@dates\n";


foreach $thedate (@dates){
    if(!$datepat || $thedate=~ m/^$datepat/){
if($thedate=~ m/(\d\d\d\d)\.(\d\d)\.(\d\d)/){
    $year=$1;
    $mon=$2;
    $day=$3;
    $doy=sprintf("%3.3d",&Date_DayOfYear($mon,$day,$year));
}
system("date");
print "\n$thedate $year $doy\n";
if("$thedate"){
#$mydir="/data/dstore3/iri/monitoring/data/data8/usgs/landdaac/$subdir/$thedate/";if(! -e $mydir ){
# change from dstore to /Data/data8
$mydir="/Data/data8/usgs/landdaac/$subdir/$thedate/";if(! -e $mydir ){
#$mydir="/Data/data8/usgs/landdaac/MOLT/MOD13Q1.006_test/$thedate/";if(! -e $mydir ){
system("mkdir -p $mydir");
}
chdir($mydir)or die "$mydir not found\n";
#
#
#  system("wget -L --load-cookies ~/.cookies2 --save-cookies ~/.cookies2 -A 'MOD13Q1.A20?????.h??v??.006.20???????????.hdf' -o wget_MODISv006_log.txt -N -r -l1 -e robots=off --no-parent -nd https://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.006/$thedate/");
#
#
foreach $file (getdatafiles("https://$hostname/$subdir/$thedate/",qr/.hdf$/)){ 
print "got $file\n";
}
my $filecount = `find $mydir -name '*.hdf' -type f ! -name filecount  | wc -l`;
chop $filecount;
$process="";
if($filecount >= $targetfilecount){
if(! -e "$mydir/filecount" ){
    $process="1";
    system("echo $filecount > $mydir/filecount");
}
}
    print "Have $filecount of $targetfilecount files for $year $mon $day\n";

#processes tiles for old versions
#
    $set="A$year$doy";
if($process){
print "processing tiles for old versions";
    system("nice -19 /Data/data8/usgs/landdaac/processdata250mTERRA_v006-use $set $year $doy $thedate");
}
else {
    print "don't need to run processdata250mTERRA_v006-use $set $year $doy $thedate\n";
}

}
}
}

exit;

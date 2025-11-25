#! /usr/freeware/bin/perl

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("anonymous");

use POSIX "ctime";
$GNUDATE="/ClimateGroup/network/gnu/bin/date";
$DataCat="/Data/data1/DataCatalog/entries";
$subdir="Climate Division Data";
$year=`date +%Y`;
print "Updating $subdir\n";
$server="ftp.ncdc.noaa.gov";
$sdir="/pub/data/cirs";
$filename= "pcp";
$suffix=".txt";
chdir "/Data/data8/noaa/ncdc/cirs";
open(out,"|ftp -n $server > ftpsession");
print out <<eoftp;
user $user $passwd
binary
hash
cd $sdir
ls
eoftp
close(out);
open(in,"ftpsession");
while(<in>){
if(m/([^ ]+)\.$filename$suffix/){
    $prefix = $1;
    print "$prefix.$filename$suffix found\n";
	if(m/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) +(\d\d?) +(\d?\d:\d\d)/){
	$time="$3 $1 $2 $year EST";
	$ntime=`$GNUDATE -d "$time" +%s`;
    print $time $ntime;
	chop $ntime;
	}
}}
close(in);
($ev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat $filename;
if($ntime < $mtime){
print "not yet updated\n";
exit
}
print "getting the new files with prefix $prefix...";
open(out,"|ftp -n $server > ftpsession");
print out <<eoftp;
user $user $passwd
binary
hash
cd $sdir
eoftp
    foreach $filename ( "pcp", "pcpst", "pdsi" , "pdsist", "phdi", "phdist", "pmdi", "pmdist", "tmp", "tmpst", "zndx", "zndxst", "cdd", "hdd" ) {
print out "get $prefix.$filename$suffix $filename\n";
}
close(out);
#create gen file
open(out,'>cirs.gen');
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
$year+=1900;
$ensoint=($mon)+12*($year-1960)-1;
$timecnt = $ensoint + 781;
$ensotime=$ensoint . ".5";
print "$ensotime\n";
print out <<"eof";
dim T $timecnt
dim IDIV 344
var T DF4 ( T )
att long_name STR time
att units STR monthtime
val -779.5 $ensotime
var IDIV DI4 ( IDIV )
att long_name STR climate division
att units ids
var lon DF4 ( IDIV )
att units STR longitude
att long_name longitude
att scale_min DF4 -125
att scale_max DF4 -65
var lat DF4 ( IDIV )
att units STR latitude
att long_name latitude
att scale_min DF4 15
att scale_max DF4 55
var pcp DF4 ( T IDIV )
att long_name precipitation
att units in
att missing_value DF4 -9.99
var tmp DF4 ( T IDIV )
att long_name temperature
att units Fahrenheit
att missing_value DF4 -99.9
var pdsi DF4 ( T IDIV )
att long_name palmer dsi
att description palmer drought severity index
att missing_value DF4 -99.99
var phdi DF4 ( T IDIV )
att long_name palmer hdi
att description palmer hydro drought index
att missing_value DF4 -99.99
var zndx DF4 ( T IDIV )
att long_name palmer zindex
att missing_value DF4 -99.99
var pmdi DF4 ( T IDIV )
att long_name modified palmer dsi
att missing_value DF4 -99.99
var cdd DF4 ( T IDIV )
att long_name cooling degree days
att missing_value DF4 -9999.
var hdd DF4 ( T IDIV )
att long_name heating degree days
att missing_value DF4 -9999.
eof
close(out);
system("./createcuf");



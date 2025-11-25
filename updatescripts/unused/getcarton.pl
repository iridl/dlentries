#! /usr/freeware/bin/perl

my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("anonymous");

use POSIX "ctime";
$GNUDATE="/ClimateGroup/network/gnu/bin/date";
$DataCat="/Data/data1/DataCatalog/entries";
$subdir="Carton GOA";
$year=`date +%Y`;
print "Updating $subdir\n";
$server="ftp.meto.umd.edu ";
$sdir="pub/outgoing/cao/beta7";
#$filename= "beta6_xbt_slt_9098.dat.gz";
$fileprefix="asm16_";
$filename= $fileprefix . "9501.tar.gz";
$ctlfile = "beta7_ts.ctl";
chdir "/Data/data6/carton/goa/beta7";
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
if(m/$filename/){
	if(m/(Jan|Feb|Mar|Apr|Jun|Jul|Aug|Sep|Oct|Nov|Dec) + (\d\d?) (\d?\d:\d\d)/){
	$time="$3 $1 $2 $year EST";
	$ntime=`$GNUDATE -d "$time" +%s`;
	chop $ntime;
	}
}}
close(in);
($ev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat "beta7.ctl";
if($ntime < $mtime){
print "not yet updated\n";
exit
}
print "getting the new file ...";
open(out,"|ftp -n $server");
print out <<eoftp;
user $user $passwd
binary
cd $sdir
get $filename
get $ctlfile
eoftp
close(out);
# adds units to the ctl file
open (in,"$ctlfile");
open (out,">beta7.ctl");
#print out "DECBINARY\n";
while(<in>){
s/99     temperature/Celsius_scale     temperature/;
s/99     salinity/PSU     salinity/;
s;99     zonal velocity;m/s     zonal velocity;;
s;99     meridional velocity;m/s     meridional velocity;;
s;99 +surface zonal wind stress;dyne/cm2     surface zonal wind stress;;
s;99 +surface meridional wind stress;dyne/cm2     surface meridional wind stress;;
s;99 +surface height;m     surface height;;
s;99 +20 degree depth;m     20 degree depth;;
s;99 +hc;"m degree_C"     hc;;
    print out;
}
close(in);
system("zcat $filename | tar xvf -; rm $filename");



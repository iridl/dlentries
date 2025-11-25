#! /usr/bin/perl
# updated to run on iridlc4 20110311 JdC
use POSIX "ctime";

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("anonymous");

$GNUDATE="/bin/date";
$DataCat="/crunch/c14/benno/Data/data1/DataCatalog/entries";
$subdir="Daily OLR";
$year=`date +%Y`;
$? == 0 or die;
chomp $year;
print "Updating $subdir\n";
$server="ftp.cdc.noaa.gov";
$sdir="/Datasets/interp_OLR";
$filename= "olr.day.mean.nc";
chdir("/Data/data8/noaa/cpc/dailyolr") or die;
open(out,"|ftp -n $server > ftpsession") or die;
print out <<eoftp;
user $user $passwd
binary
hash
cd $sdir
ls
eoftp
close(out) or die;
open(in,"ftpsession") or die;
while(<in>){
print;
if(m/\d\s+$filename/){
print "found $filename\n";
	if(m/(Jan|Feb|Mar|Apr|Jun|Jul|Aug|Sep|Oct|Nov|Dec) +(\d\d?) (\d?\d:\d\d)/){
	    if ($1 eq "Dec"){
		$year=`$GNUDATE -d '1 month ago' +%Y`;
	    }
	$time="$3 $1 $2 $year EST";
	print "time is $time\n";
        # date -d doesn't accept a timezone unless TZ environment variable is set.
	$ENV{'TZ'} = 'EST';
	$ntime=`$GNUDATE -d "$time" +%s`;
        $? == 0 or die;
	chop $ntime;
	}
}}
close(in) or die;
($ev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat $filename;
if($ntime < $mtime){
print "$ntime vs $mtime not yet updated\n";
exit;
}
else {
print "getting the new file ...";
open(out,"|ftp -n $server > ftpsession") or die;
print out <<eoftp;
user $user $passwd
binary
hash
cd $sdir
get $filename /Data/data8/noaa/cpc/dailyolr/$filename
eoftp
close(out) or die;
}
#moves all the attributes to the front of the file
#and change the time grid
print "running ingrid ...";
open(out,"|/usr/local/bin/ingrid") or die;
print out <<"eoc"; 
\\begin{ingrid}
(/Data/data8/noaa/cpc/dailyolr/$filename) readfile
olr time first 
     17298624. eq % 1 Jun 1974
      {
      name (days since 1974-01-01) ordered 151.5 1 npts
            1 sub
	          2 index add
	                NewEvenGRID
		         replaceGRID
		        name exch def
		      olr .time
		     name exch def
		   info
	          time olr .time replaceGRID
	         name exch def
	     }
	 {pop pop} ifelse
info
    missing_value type /stringtype eq {/missing_value 32766 def} if
name exch def
(/Data/data6/noaa/cpc/dailyolr/olr.day.mean.cuf)writeCUF
\\end{ingrid}
eoc
close(out) or die;
system("cp -p /Data/data8/noaa/cpc/dailyolr/olr.day.mean.nc /Data/data6/noaa/cpc/dailyolr/") == 0 or die;
print "done\n";


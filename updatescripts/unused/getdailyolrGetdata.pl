#! /usr/freeware/bin/perl

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("anonymous");

use POSIX "ctime";
$GNUDATE="/usr/freeware/bin/date";
$DataCat="/Data/data1/DataCatalog/entries";
$subdir="Daily OLR";
$year=`date +%Y`;
print "Updating $subdir\n";
$server="ftp.cdc.noaa.gov";
$sdir="/Datasets/interp_OLR";
$filename= "olr.day.mean.nc";
chdir "/Data/data8/noaa/cpc/dailyolr";

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
print;
if(m/\d\s+$filename/){
print "found $filename\n";
	if(m/(Jan|Feb|Mar|Apr|Jun|Jul|Aug|Sep|Oct|Nov|Dec) +(\d\d?) (\d?\d:\d\d)/){
	    if ($1 eq "Dec"){
		$year=`$GNUDATE -d '1 month ago' +%Y`;
	    }
	$time="$3 $1 $2 $year EST";
	print "time is $time";
	$ntime=`$GNUDATE -d "$time" +%s`;
	chop $ntime;
	}
}}
close(in);

($ev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat $filename;
if($ntime < $mtime){
print "$ntime vs $mtime not yet updated\n";
exit;
}
else {
print "getting the new file ...";
open(out,"|ftp -n $server > ftpsession");
print out <<eoftp;
user $user $passwd
binary
hash
cd $sdir
get $filename /Data/data8/noaa/cpc/dailyolr/$filename
eoftp
close(out);
}


#moves all the attributes to the front of the file
#and change the time grid
print "running ingrid ...";
open(out,"|/usr/local/bin/ingrid");
print out <<"eoc"; 
\\begin{ingrid}
(/Data/data8/noaa/cpc/dailyolr/$filename) readfile
olr time first cvsunits
     (1 Jun 1974) eq
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
close(out);
system("cp -p /Data/data8/noaa/cpc/dailyolr/olr.day.mean.nc /Data/data6/noaa/cpc/dailyolr/");
print "done\n";


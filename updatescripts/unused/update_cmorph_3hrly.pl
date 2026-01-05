#!/usr/bin/perl
#Script updates modified 3-hrly CMORPH files
#EKG 16 Oct 2002
# modified 5 Sep 2005 to use proxy and not use Net::FTP
# modified 13 Sep 2005 to use function from getdatafile
# applied to CMORPH 23 Sep 05

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles_recompress.pl";

#open (out, ">outputlog");

chdir "/Data/data6/noaa/cpc/cmorph/3-hrly" or die "Couldn't change local directory! (1)\n";

#my $host = 'ftpprd.ncep.noaa.gov';				#ftp host
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host

#my @dirs = qw(/pub/precip/global_CMORPH/3-hourly_025deg/);
my @dirs = qw(/precip/global_CMORPH/3-hourly_025deg/);

foreach $directory (@dirs) {				

	getdatafiles ("ftp://$host$directory",qr/$/,1);

	$i=0; $flag=0;
	$length=@changedfiles;
	while ($i<$length) {
		if ($changedfiles[$i]=~/201/) {
			$lastfile=$changedfiles[$i];
			$flag=1;
		}
		$i++;
	}
	if ($flag==1) {						#only modify enddate file if new files are downloaded
#	if ($lastfile=~/(\d\d\d\d)(\d\d)(\d\d)_3hr/) {
	if ($lastfile=~/025DEG_(\d\d\d\d)(\d\d)(\d\d)/) {
		$yr=$1; $mon=$2; $day=$3;
		if ($mon=~/01/) { $montxt='Jan'; }
		elsif ($mon=~/02/) { $montxt='Feb'; }
		elsif ($mon=~/03/) { $montxt='Mar'; }
		elsif ($mon=~/04/) { $montxt='Apr'; }
		elsif ($mon=~/05/) { $montxt='May'; }
		elsif ($mon=~/06/) { $montxt='Jun'; }
		elsif ($mon=~/07/) { $montxt='Jul'; }
		elsif ($mon=~/08/) { $montxt='Aug'; }
		elsif ($mon=~/09/) { $montxt='Sep'; }
		elsif ($mon=~/10/) { $montxt='Oct'; }
		elsif ($mon=~/11/) { $montxt='Nov'; }
		elsif ($mon=~/12/) { $montxt='Dec'; }

		open (endfile, ">enddate");
		print endfile "\\begin{ingrid}\n";
		print endfile "$day $montxt $yr\n";
		print endfile "\\end{ingrid}\n"; 
	}
	}
}							#end directory foreach


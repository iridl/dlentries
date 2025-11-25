#!/usr/bin/perl
#Script writes the enddate for the GMSM dataset based on the latest monthly file to be downloaded
#no longer Triggered by write_enddate.x -- does the data download too 3 Oct 2005
#E.Grover-Kopec, 30 Mar 05

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
chdir("/Data/data7/noaa/ncep/gmsm");

$flag=0;
foreach $line (getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/wd51yf/global_monthly/",qr/w\.20[0-9][5-9].*/)) {
    $flag=1;
	if ($line =~ /w\.(20\d\d)(\d\d)/ ) {
		$yr=$1;	$mo=$2;
	}
}

if ($mo=~/01/) { $motxt='Jan'; }	elsif ($mo=~/02/) { $motxt='Feb'; }
elsif ($mo=~/03/) { $motxt='Mar'; }	elsif ($mo=~/04/) { $motxt='Apr'; }
elsif ($mo=~/05/) { $motxt='May'; }	elsif ($mo=~/06/) { $motxt='Jun'; }
elsif ($mo=~/07/) { $motxt='Jul'; }	elsif ($mo=~/08/) { $motxt='Aug'; }
elsif ($mo=~/09/) { $motxt='Sep'; }	elsif ($mo=~/10/) { $motxt='Oct'; }
elsif ($mo=~/11/) { $motxt='Nov'; }	elsif ($mo=~/12/) { $motxt='Dec'; }

if ($flag==1) {					#only overwrite enddate file if newfiles had content
	open (out, ">/Data/data7/noaa/ncep/gmsm/enddate");
	print out "\\begin{ingrid}\n";
	print out "16 $motxt $yr\n"; 
	print out "\\end{ingrid}\n";
}

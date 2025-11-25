#!/usr/local/bin/perl
#Script updates modifies GPCPv2 data files
#EKG 4 Oct 2002
#To us on nino change the following lines:
#/usr/freeware/bin/perl
#system ("gzcat $nino_dir/$name | od | tail -3 >tailfile");

#modified from GPCPv2 script to handle the 1DD version -> 13 Sep 05

use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;
use HTTP::Date;
use File::Listing;

#open (out, ">outputlog");

chdir "/Data/data7/nasa/gpcp/1DD";
#system ("cd /Data/data7/nasa/gpcp/v2");				#script can be run from anywhere on nino

print "Connecting to host...\n"; 

my $host = 'rsd.gsfc.nasa.gov';						#ftp host
my @dirs = qw(/pub/1dd/);

$gtmonth=0;
$newfile=0;

print "Logged on to host...\n"; 

$ua = LWP::UserAgent->new();
$ua->agent("IRI Data Library");

foreach $directory (@dirs) {	
									#used for stat function and moving files
	$url="ftp://$host$directory";
	$req = HTTP::Request->new(GET => $url);
	$res = $ua->request($req);	

	$listing=$res->content;

	for (parse_dir($listing)) {	#parse directory listing to get filenames
		($name, $type, $size, $mtime)=@$_;
	if ($name=~/p1d/) {
	unless ($name=~/provisional/) {
if ($name=~/2007/) {
		$filename =  $name;
		@name_part = split(/\./, $filename);
		$name_nogz="$name_part[0].$name_part[1]";		#removes gz suffix on filename
		$modtime = (stat("$name_nogz"))[9];			#gives modtime the time of last modification of current version of file
		if ($modtime == 0) {$modtime=1;}			#creates generic modtime so new files will be downloaded
		$modtime=$modtime+86400;
		print "$name_nogz $modtime\n"; 

		$url="ftp://$host$directory$filename";
		my $req = HTTP::Request->new(GET => $url);

#		$req->header('If-Modified-Since' => "01 $modmon $modyear 00:00:00 GMT");
		$req->header('If-Modified-Since' =>  HTTP::Date::time2str($modtime));
		$res = $ua->request($req,$filename);	#download file based on date of modification

		utime $mtime, $mtime, $filename;	#sets access and modification time to that of original file
		if ($res->is_success()) {
			print "$name : Latest version has been downloaded.\n";
			$newfile=1;			
			getdate();	#creates date for enddate file
					#return is $daytxt, $montxt and $yrtxt
		}
		else {
			print "$name : File has not been modified or operation failed.\n";
		}
}
	}
	}
	}				#end parse loop
}				#end directory foreach


if ($newfile==1) {			#edit enddate file only if a file has been downloaded
print "New file found - - looking for the new end date...\n";
	open (end, ">enddate");		#create enddate file
	print end "\\begin{ingrid}\n";
	print end "$daytxt $montxt $yrtxt\n";
	print end "\\end{ingrid}\n";
	close(end);
}
#################################################################################

sub getdate {
	system ("gunzip -f $filename");	#uncompress downloaded file
	if ($name_part[1]=~/(\d\d\d\d)(\d\d)/) {			#$name_part[1] should be the yyyymm on the last file in the list 
		$yrtxt=$1;
		$gtmonth=$2;

		if ($gtmonth==1) {$montxt='Jan'; $daytxt='31'; }
		if ($gtmonth==2) { 
			$montxt='Feb'; 
			if ($yrtxt%4==0) { $daytxt='29'; }
			else { $daytxt='28'; }
		}
		if ($gtmonth==3) {$montxt='Mar'; $daytxt='31'; }
		if ($gtmonth==4) {$montxt='Apr'; $daytxt='30'; }
		if ($gtmonth==5) {$montxt='May'; $daytxt='31'; }
		if ($gtmonth==6) {$montxt='Jun'; $daytxt='30'; }
		if ($gtmonth==7) {$montxt='Jul'; $daytxt='31'; }
		if ($gtmonth==8) {$montxt='Aug'; $daytxt='31'; }
		if ($gtmonth==9) {$montxt='Sep'; $daytxt='30'; }
		if ($gtmonth==10) {$montxt='Oct'; $daytxt='31'; }
		if ($gtmonth==11) {$montxt='Nov'; $daytxt='30'; }
		if ($gtmonth==12) {$montxt='Dec'; $daytxt='31'; }
	}
}

####################################################################################
#Set Modified Time Standard
#system ("date +%m%Y >date");	#find current date with format MoYear
#open (in, "date");
#while (<in>) {
#	if ($_=~/([0-9]{2})(2[0-9]{3})/) {
#		$mon=$1;	#store month and year into $mon and $year
#		$year=$2;
#	}
#}
#$modmon=$mon-1;			#store modified time standard in $modmon and $modyear
#if ($modmon == 0) {		#account for Jan-Dec
#	$modmon=12;
#	$modyear=$year-1;
#}
#else {
#	$modyear=$year;
#}





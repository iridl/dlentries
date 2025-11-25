#!/usr/local/bin/perl
#Script updates modifies GPCPv2 data files
#EKG 4 Oct 2002
#To us on nino change the following lines:
#/usr/freeware/bin/perl
#system ("gzcat $nino_dir/$name | od | tail -3 >tailfile");


use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;
use HTTP::Date;
use File::Listing;

#open (out, ">outputlog");

chdir "/Data/data7/nasa/gpcp/v2";
#system ("cd /Data/data7/nasa/gpcp/v2");	#script can be run from anywhere on nino

print "Connecting to host...\n"; 

my $host = 'precip.gsfc.nasa.gov';		#ftp host
my @dirs = qw(/pub/gpcp-v2/psg/ /pub/gpcp-v2/esg/ /pub/gpcp-v2/int/);
#my @dirs = qw(/pub/gpcp-v2/psg);

$gtmonth=0;
$newfile=0;

print "Logged on to host...\n"; 

$ua = LWP::UserAgent->new();
$ua->agent("IRI Data Library");

foreach $directory (@dirs) {	#psg, int, esg
	if ($directory=~/pub\/gpcp-v2\/(\w{3})/) {$nino_dir=$1;}	#nino_dir has value of psg, int, or esg
									#used for stat function and moving files
	$url="ftp://$host$directory";
	$req = HTTP::Request->new(GET => $url);
	$res = $ua->request($req);	

	$listing=$res->content;

	for (parse_dir($listing)) {	#parse directory listing to get filenames
		($name, $type, $size, $mtime)=@$_;

		$filename =  $name;
		@name_part = split(/\./, $filename);
		$name_nogz="$name_part[0].$name_part[1]";		#removes gz suffix on filename
		$modtime = (stat("$nino_dir/$name_nogz"))[9];		#gives modtime the time of last modification of current version of file
		if ($modtime == 0) {$modtime=1;}			#creates generic modtime so new files will be downloaded
		$modtime=$modtime+86400;
		print "$filename $modtime\n"; 

		$url="ftp://$host$directory$filename";
		my $req = HTTP::Request->new(GET => $url);

#		$req->header('If-Modified-Since' => "01 $modmon $modyear 00:00:00 GMT");
		$req->header('If-Modified-Since' =>  HTTP::Date::time2str($modtime));
		$res = $ua->request($req,$filename);	#download file based on date of modification
		
		utime $mtime, $mtime, $filename;	#sets access and modification time to that of original file
		$newfile=0;
		if ($res->is_success()) {
			print "$name : Latest version has been downloaded.\n";
			$newfile=1;			
			system ("mv $filename $nino_dir");	#move new files to correct dir **overwrites files**
			unless ($filename=~/provisional/) {
				getdate();	#creates date for enddate file
			}
		}
		else {
			print "$name : File has not been modified or operation failed.\n";
		}
	}				#end parse loop
}				#end directory foreach


if ($newfile==1) {			#edit enddate file only if a file has been downloaded
	open (end, ">enddate");		#create enddate file
	print end "\\begin{ingrid}\n";
	print end "$montxt $yrtxt\n";
	print end "\\end{ingrid}\n";
	close(end);
}
#################################################################################

sub getdate {
	system ("gzcat $nino_dir/$name | od | tail -3 >tailfile");
	system ("gunzip -f $nino_dir/$filename");	#uncompress downloaded file
	open (tail, "tailfile");
	$i=0;
	while ($line=<tail>) {
		chomp($line);
		if ($i==0) {
			if ($line=~/\*/) { $montxt='Dec'; $yearfull=1; }
			@fields=split(/\s/, $line);
			$end=$fields[0];
		}
		if ($i==2) {
			$length=$line;
		}
		$i++;
	}

	if ($name=~/(\d{4})/) {$yrtxt=$1;}

	unless ($yearfull==1) {

		$months_in_file=(($end*14)/$length)-(($end*14) % $length)/$length;
#		$months_in_file=(($end*14)/$length)+($length % ($end*14))/$length;
		if ($months_in_file>=$gtmonth) {$gtmonth=$months_in_file;}
		$montxt='Jan';
		if ($gtmonth==1) {$montxt='Jan';}
		if ($gtmonth==2) {$montxt='Feb';}
		if ($gtmonth==3) {$montxt='Mar';}
		if ($gtmonth==4) {$montxt='Apr';}
		if ($gtmonth==5) {$montxt='May';}
		if ($gtmonth==6) {$montxt='Jun';}
		if ($gtmonth==7) {$montxt='Jul';}
		if ($gtmonth==8) {$montxt='Aug';}
		if ($gtmonth==9) {$montxt='Sep';}
		if ($gtmonth==10) {$montxt='Oct';}
		if ($gtmonth==11) {$montxt='Nov';}
		if ($gtmonth==12) {$montxt='Dec';}

print "$months_in_file  $end  $length  $gtmonth\n";
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





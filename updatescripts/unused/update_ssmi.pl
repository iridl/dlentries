#!/usr/bin/perl
#Script updates modified SSMI data files
#EKG 16 Dec 2002

use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;
use HTTP::Date;
use File::Listing;
use Net::FTP;

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $pswd) = get_credential("anonymous");

#open (out, ">outputlog");
chdir "/Data/data7/noaa/ncdc/ssmi";		#script can be run from anywhere on nino

my $host = 'ftp.ncdc.noaa.gov';				#ftp host
my @dirs = qw(/pub/data/satellite/ssmidata/);

$gtmonth=0;
$newfile=0;

my $ftp = Net::FTP->new($host);				#Login to ftp server
unless (defined $ftp) {
                 print "$@\n";
                 die "Can't create Net::FTP-Object\n";
}
$ftp->login($user, $pswd);

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)
$ftp->cwd($directory) or die "Couldn't change directory!\n";


	for (parse_dir($ftp->ls('-lR'))) {		#parse directory listing to get annual directories
		($yr_dir, $type, $size, $mtime)=@$_;
		unless ($yr_dir=~/\//) {
		$ftp->cwd($yr_dir) or die "Couldn't change to directory $yr_dir\n";


		system ("ls -l $yr_dir > outfile");
		open (in, "outfile");
		if (<in>) {			
			chdir "$yr_dir";		
		}
		else { 
			system ("mkdir $yr_dir"); 	
			chdir "$yr_dir";		
		}
		close (in);

		for (parse_dir($ftp->ls('-lR'))) {		#parse directory listing to get filenames
			($filename, $type, $size, $mtime)=@$_;
#	print "FTP Time: $mtime, ";
			$modtime = (stat("$filename"))[9];	#gives modtime the time of last modification of current version of file
#	print "NINO Time: $modtime\n";
			if ($modtime == 0) {$modtime=1;}	#creates generic modtime so new files will be downloaded
			my $url = "ftp://$host/$directory$yr_dir/$filename";
			my $ua = LWP::UserAgent->new();
			$ua->agent("IRI Data Library");
	
			my $req = HTTP::Request->new(GET => $url);

			if ($mtime > $modtime) {
#			$req->header('If-Modified-Since' =>  HTTP::Date::time2str(1034308800));
			$res = $ua->request($req,$filename);	#download file based on date of modification
			

			utime $mtime, $mtime, $filename;	#sets access and modification time to that of original file
#			if ($res->is_success()) {
				print "$filename : Latest version has been downloaded.\n";
			}
			else {
#				print "$filename : File has not been modified.\n";
			}
		}						#end unless condition
		}						#end parse loop
		chdir "..";
#		print "Changing to 2 $directory\n";
		$ftp->cwd("/pub/data/satellite/ssmidata/") or die "Couldn't change directory to ssmidata!\n";
#		print "MADE IT1\n";
	}							#end parse loop
}								#end directory foreach

$ftp->quit();


#################################################################################









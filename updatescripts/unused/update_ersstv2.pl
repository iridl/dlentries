#!/usr/bin/perl -w

#Script updates modified ERSSTv2 data files
#v1 version: EKG 23 Jan 2003
#v2 version: 6 May 2004

use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;
use HTTP::Date;
use File::Listing;

#open (out, ">outputlog");
chdir "/Data/data6/noaa/ncdc/ersstv2";	#script can be run from anywhere


my $host = 'ftp.ncdc.noaa.gov';				#ftp host

my @dirs = qw(/pub/data/ersst-v2/);

$ua = LWP::UserAgent->new();
$ua->agent("IRI Data Library");


foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)


    $url="ftp://$host$directory";
    
			$req = HTTP::Request->new(GET => $url);
			$res = $ua->request($req);  
    $listing=$res->content;
	for (parse_dir($listing)) {		#parse file listing to get filenames
		($filename, $type, $size, $mtime)=@$_;


                 if ($filename =~/ersst.v2.*asc.Z/) {	#download data files only
                    if($filename =~ /ersst.v2.\d\d\d\d.\d\d\d\d.asc.Z/) {
                      $fn = substr($filename,0,22);
                    } elsif ($filename =~ /ersst.v2.serrv.\d\d\d\d.\d\d\d\d.asc.Z/) {
                      $fn = substr($filename,0,28);
                    } else { 
                      die "No matching data files found.\n"; 
                    }
			$modtime = (stat($fn))[9];	#gives modtime the time of last modification of current version of file

#Need to use different filename variables for local uncompressed and remote compressed files
			if ($modtime == 0) {$modtime=1;}	#creates generic modtime so new files will be downloaded
			$url = "ftp://$host$directory$filename";
	
			$req = HTTP::Request->new(GET => $url);
	
			$req->header('If-Modified-Since' =>  HTTP::Date::time2str($modtime+60));
			$res = $ua->request($req,$filename);	#download file based on date of modification
				
			if ($res->is_success()) {
				print "$filename : Latest version has been downloaded.\n";
                                system("uncompress -f $filename");
			        utime $mtime, $mtime, $filename;	#sets access and modification time to that of original compressed file
			}
			else {
				print "$filename : File has not been modified or operation failed.\n";
			}
		}					#end filename condition if statement
	}						#end parse loop
}							#end directory foreach



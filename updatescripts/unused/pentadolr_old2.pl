#!/usr/bin/perl -w

#Script to update pentad olr values. 
#Modified from script created by EKG to download EPTOMS aerosol index files 
#September 21, 2003

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

 chdir "/Data/data8/noaa/cpc/olr";
# script can be run from anywhere on nino

my $ldir = '/Data/data8/noaa/cpc/olr/';  #base directory for olr 
my $host = 'nomad3.ncep.noaa.gov';				#ftp host
#my $host = 'wesley.wwb.noaa.gov';				#ftp host
my @dirs = qw(pub/cpc/olr/pentad/);               #array of directories
#my @dirs = qw(pub/tmpdisk/cpc/olr/pentad/);               #array of directories

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

      for (parse_dir($ftp->ls('-l'))) {   #parse files in dir


        ($filename, $type, $size, $mtime)=@$_;
                

		$modtime = (stat("$filename"))[9];	#gives modtime the time of last modification of current local version of file

		unless(-e $filename) {$modtime=1;}	#creates generic modtime for files that do not exist locally, but are available on the remote machine 

		my $ua = LWP::UserAgent->new();
		$ua->agent("IRI Data Library");

                if($mtime > ($modtime+60) && $filename =~ /\bpent.olr.y2\d\d\d\b/) { 

# if the modification time of the remote file is more recent than that of an existing
# local (or non-existent file given a generic small modification time) and if the filename matches the structure for recent olr filenames then get the
# more recent file from the remote machine
 
                 print "$filename\n"; 
                 $res1 = $ftp->get($filename,$filename);    #download file based on date of modification
		
 		 utime $mtime, $mtime, $filename;	#sets access and modification time to that of original file

                 if ($res1){
                   print "$filename was downloaded.\n";
                   system("make olr");
                 } 

		}   # end of modification time and filename check for olr 


                if($mtime > ($modtime+60) && $filename =~ /\bpent.olra.y2\d\d\d\b/) {

# now checking for olra files

                 print "$filename\n"; 
                 $res2 = $ftp->get($filename,$filename);    #download file based on date of modification
		
 		 utime $mtime, $mtime, $filename;	#sets access and modification time to that of original file

                 if ($res2){
                   print "$filename was downloaded.\n";
                   system("make olra");
                 } 

		}   # end of modification time and filename check for olra 

       }     # end of parse_dir 'for' loop

}							#end directory foreach

$ftp->quit();


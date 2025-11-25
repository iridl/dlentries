#!/usr/bin/perl -w

#Script to update EPTOMS TOMS aerosol and erythemal uv values.  This
#script, "eptomsmonthlyupdate2.pl" was modified from "eptomsmonthlyupdate.pl"
#to download both aerosol AND erythemal uv values. 
#Modified from script created by EKG to download CAMS-OPI v0208 files
#January 21, 2003

use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;
use HTTP::Date;
use File::Listing;
use Net::FTP;

my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";
my ($user, $pswd) = get_credential("anonymous");

#open (out, ">outputlog");

 chdir "/Data/data6/nasa/gsfc/toms/eptoms/monthly_averages";
# script can be run from anywhere on nino

my $host = 'jwocky.gsfc.nasa.gov';				#ftp host
my @dirs = qw(/pub/eptoms/data/monthly_averages/aerosol/  /pub/eptoms/data/monthly_averages/uv/);               #array of directories

$gtmonth=0;
$newfile=0;

my $ftp = Net::FTP->new($host);				#Login to ftp server
unless (defined $ftp) {
                 print "$@\n";
                 die "Can't create Net::FTP-Object\n";
}
$ftp->login($user, $pswd);

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)
	$ftp->cwd($directory) or die "Couldn't change remote directory!\n";

        if($directory eq '/pub/eptoms/data/monthly_averages/aerosol/') {
          chdir "/Data/data6/nasa/gsfc/toms/eptoms/monthly_averages/aerosol";
        } elsif ($directory eq '/pub/eptoms/data/monthly_averages/uv/') {
          chdir "/Data/data6/nasa/gsfc/toms/eptoms/monthly_averages/uv";
        } else { 
          die "Couldn't change local directory!\n";
        }

      for (parse_dir($ftp->ls('-lR'))) {         #parse files in aerosol directory
        ($filename, $type, $size, $mtime)=@$_;
                

		$modtime = (stat("$filename"))[9];	#gives modtime the time of last modification of current local version of file

		unless(-e $filename) {$modtime=1;}	#creates generic modtime for files that do not exist locally, but are available on the remote machine 

		my $ua = LWP::UserAgent->new();
		$ua->agent("IRI Data Library");

                if($mtime > ($modtime+60) && ($filename =~ /\bgm\d\d\d\d.ep[ae]\b/)) { 

# if the modification time of the remote file is more recent than that of an existing
# local (or non-existent file given a generic small modification time), then get the
# more recent file from the remote machine
 
                 print "$filename\n"; 
                 $ftp->get($filename,$filename);    #download file based on date of modification
		
 		 utime $mtime, $mtime, $filename;	#sets access and modification time to that of original file

       # need to check for a successful download here

		}   # end of modification time check 

       }     # end of parse_dir 'for' loop

}	#end directory foreach

$ftp->quit();

